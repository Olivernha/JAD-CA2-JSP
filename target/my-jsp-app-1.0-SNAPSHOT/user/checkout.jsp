<%@ page import="java.util.ArrayList, com.google.gson.Gson, com.ca1.models.Service" %>
<%
    // Retrieve cart and user details from session
    ArrayList<Service> cart = (ArrayList<Service>) session.getAttribute("cart");
    if (cart == null) { cart = new ArrayList<>(); }
    Integer userId = (Integer) session.getAttribute("userID"); // Ensure user is logged in
    String specialRequest = request.getParameter("specialRequest");

    // Convert cart to JSON
    Gson gson = new Gson();
    String cartJson = gson.toJson(cart);

    double total = 0.0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout Summary</title>
    <link rel="stylesheet" href="../css/home.css">
    <script src="https://js.stripe.com/v3/"></script>
    <style>
        .checkout-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            font-family: 'Urbanist', sans-serif;
        }
        .checkout-title {
            font-size: 1.8rem;
            color: #2d3436;
            font-weight: 600;
            text-align: center;
            margin-bottom: 20px;
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f1f1f1;
        }
        .summary-item img {
            width: 60px;
            height: 60px;
            border-radius: 5px;
            object-fit: cover;
        }
        .summary-details {
            flex-grow: 1;
            margin-left: 15px;
        }
        .summary-name {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2d3436;
        }
        .summary-price {
            font-size: 1rem;
            color: #6c5ce7;
            font-weight: 600;
        }
        .total-container {
            text-align: right;
            padding-top: 15px;
            border-top: 2px solid #f1f1f1;
        }
        .total-label {
            font-size: 1.4rem;
            font-weight: bold;
            color: #2d3436;
        }
        .total-amount {
            font-size: 1.4rem;
            color: #6c5ce7;
            font-weight: 700;
        }
        .checkout-btn, .update-btn {
            display: block;
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            text-align: center;
            background: #6c5ce7;
            color: white;
            font-size: 1.2rem;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
            border: none;
        }
        .checkout-btn:hover, .update-btn:hover {
            background: #5849c4;
        }
        
.address-container {
    display: flex;
    align-items: center;
    gap: 10px; /* Space between input and button */
    width: 100%;
    margin-top: 10px;
}

.address-input {
    flex-grow: 1; /* Makes the input field take up available space */
    padding: 10px;
    font-size: 1rem;
    border: 1px solid #ccc;
    border-radius: 5px;
    transition: border-color 0.3s;
}

.address-input:focus {
    border-color: #6c5ce7;
    outline: none;
}

.update-btn {
    background: #6c5ce7;
    color: white;
    font-size: 1rem;
    font-weight: bold;
    border-radius: 5px;
    cursor: pointer;
    transition: background 0.3s ease;
    border: none;
}

.update-btn:hover {
    background: #5849c4;
}

        
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="checkout-container">
    <h1 class="checkout-title">Checkout Summary</h1>

    <div class="summary-list">
        <% for (Service service : cart) {
            double serviceTotal = service.getPrice() * service.getQuantity();
            total += serviceTotal;
        %>
        <div class="summary-item">
            <img src="../<%= service.getImagePath() %>" alt="<%= service.getServiceName() %>">
            <div class="summary-details">
                <span class="summary-name"><%= service.getServiceName() %></span><br>
                <span class="summary-price">Price: $<%= String.format("%.2f", service.getPrice()) %> x <%= service.getQuantity() %></span>
            </div>
            <span class="summary-price">$<%= String.format("%.2f", serviceTotal) %></span>
        </div>
        <% } %>
    </div>

    <div class="total-container">
        <p class="total-label">Subtotal: <span class="total-amount">$<%= String.format("%.2f", total) %></span></p>
        <p class="total-label">GST (9%): <span class="total-amount">$<%= String.format("%.2f", total * 0.09) %></span></p>
        <p class="total-label">Total Amount: <span class="total-amount">$<%= String.format("%.2f", total * 1.09) %></span></p>
    </div>

    <% if (specialRequest != null && !specialRequest.isEmpty()) { %>
        <p><strong>Special Request:</strong> <%= specialRequest %></p>
    <% } %>

    <!-- Address Update Section -->
    <form action="../UpdateUserAddressServlet" method="POST">
        <label for="deliveryAddress">Delivery Address:</label>
	<div class="address-container">
	    <input type="text" id="deliveryAddress" name="newAddress" class="address-input" placeholder="Fetching address...">
	    <button type="submit" class="update-btn">Update</button>
	</div>

    </form>

    <!-- Checkout Form -->
    <form method="POST">
        <input type="hidden" name="userId" value="<%= userId %>">
        <input type="hidden" name="cartJson" value='<%= cartJson %>'>
        <input type="hidden" name="specialRequest" value="<%= specialRequest %>">
        <input type="hidden" name="total" value="<%= total * 1.09 %>">
        <button type="button" id="confirm-booking-btn" class="checkout-btn">Confirm Booking</button>
    </form>
</div>
<script>
document.addEventListener("DOMContentLoaded", function() {
    // Fetch User Address
    fetch("../GetUserAddressServlet")
    .then(response => response.json())
    .then(data => {
        console.log("Address Data Received:", data);
        const addressInput = document.getElementById("deliveryAddress");
        addressInput.value = data.address || "";
    })
    .catch(error => console.error("Error fetching address:", error));

    // Initialize Stripe
    const stripe = Stripe("pk_test_51QqRuBRtcizH9TiQWPA7rKSI8Tmy6zxRyH48WX6hBFuO68NjIpAH3VACd0713HdXfZgY9xMjGdbCrfjkZ5eIYkMY00B2NXgzrz");

    // Handle Confirm Booking Click
    document.getElementById("confirm-booking-btn").addEventListener("click", async function() {
        try {
            // Retrieve cart JSON and user ID from JSP
            const cartJson = `<%= cartJson %>`;
            const userId = "<%= userId %>";

            // Ensure amount is passed in cents
            const formData = {
                name: "Cleaning Services", // Generic name
                amount: Math.round(parseFloat("<%= total * 1.09 %>") * 100), // Convert to cents
                quantity: 1,
                currency: "usd",
                userId: userId, // Send user ID
                cartJson: cartJson // Send full cart
            };

            const response = await fetch("http://localhost:8081/ca2-ws/checkout_payment", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(formData)
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            // Get response from Stripe backend
            const stripeResponse = await response.json();

            // Redirect to Stripe Checkout
            const result = await stripe.redirectToCheckout({ sessionId: stripeResponse.sessionId });
            if (result.error) {
                console.error("Stripe Checkout Error:", result.error.message);
            }
        } catch (error) {
            console.error("Error during checkout:", error);
        }
    });
});

</script>


</body>
</html>
