<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List, com.ca1.dao.BookingDAO, com.ca1.models.BookingDetail"%>
<%@ page import="com.ca1.models.Service" %>
<%
    // Handle quantity updates
    String updateId = request.getParameter("updateId");
    String action = request.getParameter("action");

    if (updateId != null && action != null) {
        ArrayList<Service> ct = (ArrayList<Service>) session.getAttribute("cart");
        if (ct != null) {
            for (Service service : ct) {
                if (service.getId() == Integer.parseInt(updateId)) {
                    int currentQty = service.getQuantity();

                    if ("increase".equals(action)) {
                        // Increase quantity
                        service.setQuantity(currentQty + 1);
                    } else if ("decrease".equals(action) && currentQty > 1) {
                        // Decrease quantity
                        service.setQuantity(currentQty - 1);
                    } else if ("decrease".equals(action) && currentQty == 1) {
                        // Remove the service from the cart
                        ct.remove(service);
                    }

                    break; // Break the loop once the service is found and updated
                }
            }
            // Update the session with the modified cart
            session.setAttribute("cart", ct);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Elegant Shopping Cart</title>
    <link rel="stylesheet" href="../css/home.css">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        
        .cart-container {
           
            border-radius: 20px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
           
            padding: 6rem;
        }

        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f1f1f1;
        }

        .cart-title {
            font-size: 1.8rem;
            color: #2d3436;
            font-weight: 600;
        }

        .cart-count {
            background: #6c5ce7;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }

        .cart-items {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .cart-item {
            display: grid;
            grid-template-columns: auto 1fr auto;
            gap: 1.5rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 15px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .cart-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .item-image {
            width: 100px;
            height: 100px;
            border-radius: 10px;
            object-fit: cover;
        }

        .item-details {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .item-name {
            font-size: 1.2rem;
            color: #2d3436;
            margin-bottom: 0.5rem;
        }

        .item-price {
            font-size: 1.1rem;
            color: #6c5ce7;
            font-weight: 600;
        }

        .item-controls {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: white;
            padding: 0.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .quantity-btn {
            background: none;
            border: none;
            color: #6c5ce7;
            font-size: 1.2rem;
            cursor: pointer;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.3s ease;
            border-radius: 5px;
        }

        .quantity-btn:hover {
            background: #f0f0f0;
        }

        .quantity {
            font-size: 1rem;
            min-width: 30px;
            text-align: center;
        }

        .remove-btn {
            background: #ff7675;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .remove-btn:hover {
            background: #d63031;
        }

        .cart-summary {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #f1f1f1;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .total-price {
            font-size: 1.5rem;
            color: #2d3436;
            font-weight: 600;
        }

        .checkout-btn {
            background: #6c5ce7;
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 10px;
            font-size: 1.1rem;
            cursor: pointer;
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .checkout-btn:hover {
            background: #5849c4;
            transform: scale(1.05);
        }

        .empty-cart {
            text-align: center;
            padding: 2rem;
            color: #b2bec3;
            font-size: 1.2rem;
            display: none;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .cart-item {
            animation: fadeIn 0.5s ease forwards;
        }

        @media (max-width: 600px) {
            .cart-item {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .item-image {
                margin: 0 auto;
            }

            .item-controls {
                justify-content: center;
            }
        }
        .item-controls {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: white;
            padding: 0.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            min-width: 120px;
            justify-content: center;
        }

        .quantity-btn {
            background: #6c5ce7;
            border: none;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            border-radius: 5px;
        }

        .quantity-btn:hover {
            background: #5849c4;
            transform: scale(1.1);
        }

        .quantity-btn:active {
            transform: scale(0.95);
        }

        .quantity {
            font-size: 1rem;
            min-width: 40px;
            text-align: center;
            font-weight: 600;
            color: #2d3436;
        }
        .special-request {
    margin-top: 1.5rem;
    padding: 0.5rem 0;
    display: flex;
    justify-content: center;
    align-items: center;
}

.special-request input {
    width: 100%;
    max-width: 400px;
    padding: 0.75rem;
    font-size: 1rem;
    border: 1px solid #ddd;
    border-radius: 10px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    outline: none;
    transition: all 0.3s ease;
}

.special-request input:focus {
    border-color: #6c5ce7;
    box-shadow: 0 0 5px rgba(108, 92, 231, 0.5);
}

.special-request input::placeholder {
    color: #b2bec3;
    font-style: italic;
}

@media (max-width: 600px) {
    .special-request {
        justify-content: flex-start;
    }

    .special-request input {
        width: 100%;
    }
}
    </style>
</head>
<body>
 <%@ include file="header.jsp" %>

    <div class="cart-container">
        <div class="cart-header">
            <h1 class="cart-title">Shopping Cart</h1>
            <% 
                ArrayList<Service> cart = (ArrayList<Service>) session.getAttribute("cart");
                if (cart == null) {
                    cart = new ArrayList<>();
                    session.setAttribute("cart", cart);
                }
            %>
            <span class="cart-count"><%= cart.size() %> items</span>
        </div>

        <% if (cart.isEmpty()) { %>
            <div class="empty-cart">
                Your cart is empty
            </div>
        <% } else { %>
        <form action="checkout.jsp" method="POST">
         
            <div class="cart-items">
                <% 
                    double total = 0.0;
                    ServiceDAO serviceDAO = new ServiceDAO();

                    for (Service service : cart) {
                        Service product = serviceDAO.getServiceById(service.getId());
                        total += product.getPrice() * service.getQuantity();
                %>
                    <div class="cart-item">
                        <img src="../<%= product.getImagePath() %>" alt="<%= product.getServiceName() %>" class="item-image">
                        <div class="item-details">
                            <h3 class="item-name"><%= product.getServiceName() %></h3>
                            <span class="item-price">$<%= String.format("%.2f", product.getPrice()) %></span>
                        </div>
                        <div class="item-controls">
                            <div class="quantity-control">
                                <a href="?updateId=<%= service.getId() %>&action=decrease" class="quantity-btn decrease">-</a>
                                <span class="quantity"><%= service.getQuantity() %></span>
                                <a href="?updateId=<%= service.getId() %>&action=increase" class="quantity-btn increase">+</a>
                            </div>
                           
                         
                        </div>
                    </div>
                <% } %>
            </div>
			 <div class="special-request">
			 	<input type="hidden" name="total" value="<%= total %>" />
			 
                 <input type="text" name="specialRequest" placeholder="Special Request">
            </div>
            <div class="cart-summary">
                <span class="total-price">Total: $<%= String.format("%.2f", total) %></span>
                <button class="checkout-btn" type="submit">Proceed to Checkout</button>
            </div>
             </form>
        <% } %>
    </div>

    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
</body>
</html>

