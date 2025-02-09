<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.ca1.dao.ServiceDAO, com.ca1.models.Service, com.ca1.dao.FeedBackDAO, com.ca1.models.Feedback, java.util.List, java.text.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Service Details</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
     <link rel="shortcut icon" href="../img/favicon.svg" type="image/svg+xml">
	<link rel="stylesheet" href="../css/home.css">
    <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4A90E2;
            --secondary-color: #2C3E50;
            --accent-color: #E74C3C;
            --background-color: #F8FAFC;
            --text-color: #2C3E50;
        }

        * {
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Urbanist', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
        }

        .service-details {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .service-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            margin-top: 2rem;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .service-image-container {
            position: relative;
            overflow: hidden;
            height: 100%;
        }

        .service-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .service-image:hover {
            transform: scale(1.05);
        }

        .service-content {
            padding: 3rem;
        }

        .service-title {
            font-size: 2.5rem;
            color: var(--secondary-color);
            margin-bottom: 1rem;
            position: relative;
        }

        .service-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 60px;
            height: 4px;
            background: var(--primary-color);
            border-radius: 2px;
        }

        .service-description {
            font-size: 1.1rem;
            margin: 2rem 0;
            color: #666;
        }

        .price-tag {
            display: inline-block;
            background: var(--primary-color);
            color: white;
            padding: 0.5rem 1.5rem;
            border-radius: 50px;
            font-weight: 600;
            margin: 1rem 0;
        }

        .discount-badge {
            background: var(--accent-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 1rem;
            margin-left: 1rem;
            animation: pulse 2s infinite;
        }

        .booking-form {
            margin-top: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 0.8rem;
            border: 2px solid #e1e1e1;
            border-radius: 10px;
            font-family: inherit;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
        }

        .btn-book {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            width: 100%;
        }

        .btn-book:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(74, 144, 226, 0.2);
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        @media (max-width: 768px) {
            .service-container {
                grid-template-columns: 1fr;
            }

            .service-image-container {
                height: 300px;
            }
        }
        
                .service-features {
            margin-top: 4rem;
            padding: 2rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            margin-top: 2rem;
        }

        .feature-card {
            padding: 1.5rem;
            border-radius: 15px;
            background: #f8f9fa;
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .process-steps {
            margin-top: 4rem;
            padding: 2rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .timeline {
            position: relative;
            margin-top: 2rem;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 50%;
            width: 2px;
            height: 100%;
            background: var(--primary-color);
            transform: translateX(-50%);
        }

        .timeline-item {
            display: flex;
            justify-content: space-between;
            padding: 2rem 0;
        }

        .timeline-content {
            width: 45%;
            padding: 1.5rem;
            background: #f8f9fa;
            border-radius: 15px;
            position: relative;
        }

        .timeline-item:nth-child(even) {
            flex-direction: row-reverse;
        }

        .reviews-section {
            margin-top: 4rem;
            padding: 2rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .review-card {
            padding: 2rem;
            margin: 1rem 0;
            background: #f8f9fa;
            border-radius: 15px;
            position: relative;
        }

        .review-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
        }

        .reviewer-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 1rem;
            object-fit: cover;
        }

        .star-rating {
            color: #ffd700;
            margin: 0.5rem 0;
        }

        .review-date {
            color: #666;
            font-size: 0.9rem;
        }

        .write-review {
            margin-top: 2rem;
            padding: 2rem;
            background: #f8f9fa;
            border-radius: 15px;
        }

        .rating-input {
            display: flex;
            gap: 0.5rem;
            margin: 1rem 0;
        }

        .rating-input button {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #ddd;
            transition: color 0.3s ease;
        }

        .rating-input button.active {
            color: #ffd700;
        }

        @media (max-width: 768px) {
            .features-grid {
                grid-template-columns: 1fr;
            }

            .timeline::before {
                left: 0;
            }

            .timeline-item {
                flex-direction: column;
            }

            .timeline-item:nth-child(even) {
                flex-direction: column;
            }

            .timeline-content {
                width: 100%;
                margin-left: 2rem;
            }
        }
        
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <main>
        <section class="service-details">
            <% 
                int serviceId = Integer.parseInt(request.getParameter("serviceId"));
                ServiceDAO serviceDAO = new ServiceDAO();
                Service service = serviceDAO.getServiceById(serviceId);
                if (service != null) {
            %>
            <div class="service-container" data-aos="fade-up">
                <div class="service-image-container" data-aos="fade-right">
                    <img src="../<%= service.getImagePath() %>" alt="<%= service.getServiceName() %>" class="service-image">
                </div>
                <div class="service-content" data-aos="fade-left">
                    <h1 class="service-title"><%= service.getServiceName() %></h1>
                    <p class="service-description"><%= service.getDescription() %></p>
                    <div class="pricing" style="display: flex;align-items: center;gap: 10px;">  
                        <% if(service.getDiscount() > 0) { %>
                        	<del class="del">$<%= service.getPrice() %></del>
                        <% } %>
                        <span class="price-tag">$<%= service.getPrice() * (1 - (service.getDiscount() / 100.0)) %></span>
                    </div>
                    
                    <% if(service.getDiscount() > 0) { %>
                        <span class="discount-badge"><%= service.getDiscount() %>% OFF</span>
                    <% } %>
                   
                   <form class="booking-form" action="../bookingAuth.jsp" method="post">
					 <input type="hidden" name="serviceId" value="<%= serviceId %>">
					 <input type="hidden" name="serviceImage" value="<%= service.getImagePath() %>">
					 <input type="hidden" name="servicePrice" value ="<%= service.getPrice() %>">
					 <input type="hidden" name="serviceName" value = "<%= service.getServiceName() %>">
					 <input type="hidden" name="serviceFinalPrice" value="<%= service.getPrice() * service.getQuantity() %>">
					 <input type="hidden" id="selectedSlotId" name="slotId"> <!-- Hidden field for slot -->
					
					    <div class="form-group">
					        <label for="slot">Select Time Slot</label>
					        <select id="slot" name="slotDropdown" class="form-control" required>
					            <option value="">Loading slots...</option>
					        </select>
					    </div>
					
					    <div class="form-group">
					        <label for="quantity">Units</label>
					        <input type="number" id="quantity" name="quantity" min="1" value="1" class="form-control">
					    </div>
					
					    <button type="submit" class="btn-book">Book Now</button>
				   </form>
                </div>
            </div>
            <% } else { %>
                <div class="error-message" data-aos="fade-up">
                    <h2>Service not found</h2>
                    <p>The requested service could not be found. Please try again.</p>
                </div>
            <% } %>
        </section>
        
        <!-- Features Section -->
        <section class="service-features" data-aos="fade-up">
            <h2 class="section-title">Why Choose Our Service</h2>
            <div class="features-grid">
                <div class="feature-card" data-aos="fade-up" data-aos-delay="100">
                    <ion-icon name="shield-checkmark-outline" class="feature-icon"></ion-icon>
                    <h3>Professional Staff</h3>
                    <p>Experienced and well-trained professionals dedicated to quality service.</p>
                </div>
                <div class="feature-card" data-aos="fade-up" data-aos-delay="200">
                    <ion-icon name="time-outline" class="feature-icon"></ion-icon>
                    <h3>Time Efficient</h3>
                    <p>Quick and efficient service delivery without compromising quality.</p>
                </div>
                <div class="feature-card" data-aos="fade-up" data-aos-delay="300">
                    <ion-icon name="sparkles-outline" class="feature-icon"></ion-icon>
                    <h3>Satisfaction Guaranteed</h3>
                    <p>100% satisfaction guarantee with our premium cleaning services.</p>
                </div>
            </div>
        </section>

        <!-- Process Steps -->
        <section class="process-steps" data-aos="fade-up">
            <h2 class="section-title">How It Works</h2>
            <div class="timeline">
                <div class="timeline-item" data-aos="fade-right">
                    <div class="timeline-content">
                        <h3>1. Book Service</h3>
                        <p>Choose your service and preferred time slot through our easy booking system.</p>
                    </div>
                </div>
                <div class="timeline-item" data-aos="fade-left">
                    <div class="timeline-content">
                        <h3>2. Confirmation</h3>
                        <p>Receive instant confirmation and service details via email.</p>
                    </div>
                </div>
                <div class="timeline-item" data-aos="fade-right">
                    <div class="timeline-content">
                        <h3>3. Service Delivery</h3>
                        <p>Our professional team arrives and performs the service to your satisfaction.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Reviews Section -->
		<section class="reviews-section" data-aos="fade-up">
		    <h2 class="section-title">Customer Reviews</h2>
		    <%
		        FeedBackDAO feedbackDAO = new FeedBackDAO();
		        List<Feedback> feedbackList = feedbackDAO.getFeedbackByServiceId(serviceId); 
		        if (feedbackList == null || feedbackList.isEmpty()) {
		    %>
		        <p>No reviews yet.</p>
		    <% } else { %>
		        <div class="reviews-container" style="overflow-y: auto; max-height: 400px;"> <!-- Scrollable container -->
		            <% for (Feedback feedback : feedbackList) { %>
		                <div class="review-card" data-aos="fade-up">
		                    <div class="review-header">
		                        <img src="../<%= feedback.getAvatar() %>" alt="User Avatar" class="reviewer-avatar">
		                        <div>
		                            <h4><%= feedback.getCustomerName() %></h4>
		                            <div class="star-rating" style="display:flex">
		                                <% for (int i = 1; i <= feedback.getRating(); i++) { %>
		                                    <ion-icon name="star"></ion-icon>
		                                <% } %>
		                                <% for (int i = feedback.getRating() + 1; i <= 5; i++) { %>
		                                    <ion-icon name="star-outline"></ion-icon>
		                                <% } %>
		                            </div>
		                            <span class="review-date"><%= new SimpleDateFormat("MMM dd, yyyy").format(feedback.getFeedbackDate()) %></span>
		                        </div>
		                    </div>
		                    <p><%= feedback.getComment() %></p>
		                </div>
		            <% } %>
		        </div>
		    <% } %>
		</section>
    </main>

    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
  	<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
	    document.addEventListener("DOMContentLoaded", function() {
	        const slotDropdown = document.getElementById("slot");
	        const slotIdInput = document.getElementById("selectedSlotId");
	
	        fetch("../GetSlotsServlet")
	        .then(response => response.json())
	        .then(slots => {
	            slotDropdown.innerHTML = "";
	            if (slots.length === 0) {
	                slotDropdown.innerHTML = "<option value=''>No slots available</option>";
	                return;
	            }
	
	            slots.forEach(slot => {
	                let option = document.createElement("option");
	                option.value = slot.slotId;
	                option.textContent = slot.slotStartTime + " - " + slot.slotEndTime;
	                slotDropdown.appendChild(option);
	            });
	
	            // Update hidden input with selected slot ID
	            slotDropdown.addEventListener("change", function() {
	                slotIdInput.value = this.value;
	            });
	        })
	        .catch(error => {
	            console.error("❌ Error fetching slots:", error);
	            slotDropdown.innerHTML = "<option value=''>Failed to load slots</option>";
	        });
	    });

        AOS.init({
            duration: 1000,
            once: true,
            offset: 100
        });

        // Add smooth scroll behavior
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
        
        // Dynamic price calculation
        const quantityInput = document.getElementById('quantity');
        const priceTag = document.querySelector('.price-tag');
        const originalPrice = <%= service != null ? service.getPrice() : 0 %>;
        const discount = <%= service != null ? service.getDiscount() : 0 %>;

        quantityInput.addEventListener('change', function() {
            const quantity = parseInt(this.value) || 1;
            console.log(quantity);
            const total = originalPrice * quantity;
            console.log(total);
            const discountedPrice = discount > 0 ? total * (1 - discount/100) : total;
            console.log(discountedPrice);
            priceTag.textContent = '$' + discountedPrice.toFixed(2);
        });
   
    </script>
</body>
</html>