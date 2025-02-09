<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.ca1.dao.CategoryDAO, com.ca1.dao.ServiceDAO, com.ca1.models.Category, com.ca1.models.Service, java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <title>Zen.Home Cleaning</title>
  <link rel="shortcut icon" href="../img/favicon.svg" type="image/svg+xml">
  <link rel="stylesheet" href="../css/home.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Urbanist:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="preload" as="image" href="../img/logo.png">
  <link rel="preload" as="image" href="../img/hero-banner-1.jpg">
  <link rel="preload" as="image" href="../img/hero-banner-2.jpg">
  <link rel="preload" as="image" href="../img/hero-banner-3.jpg">

</head>

<body id="top">
<%@ include file="header.jsp" %>
  <!-- 
    - #MOBILE NAVBAR
  -->

  <div class="sidebar">
    <div class="mobile-navbar" data-navbar>

      <div class="wrapper">
        <a href="#" class="logo">
          <img src="../img/logo.png" width="179" height="26" alt="Glowing">
        </a>

        <button class="nav-close-btn" aria-label="close menu" data-nav-toggler>
          <ion-icon name="close-outline" aria-hidden="true"></ion-icon>
        </button>
      </div>

      <ul class="navbar-list">

        <li>
          <a href="#home" class="navbar-link" data-nav-link>Home</a>
        </li>

        <li>
          <a href="#collection" class="navbar-link" data-nav-link>Collection</a>
        </li>

        <li>
          <a href="#shop" class="navbar-link" data-nav-link>Shop</a>
        </li>

        <li>
          <a href="#offer" class="navbar-link" data-nav-link>Offer</a>
        </li>

        <li>
          <a href="#blog" class="navbar-link" data-nav-link>Blog</a>
        </li>

      </ul>

    </div>

    <div class="overlay" data-nav-toggler data-overlay></div>
  </div>

  <main>
    <article>

      <!-- 
        - #HERO
      -->

      <section class="section hero" id="home" aria-label="hero" data-section>
        <div class="container">

          <ul class="has-scrollbar">

 			<li class="scrollbar-item">
              <div class="hero-card has-bg-image" style="background-image: url('../img/hero-banner-2.png')">
                <div class="card-content">
                  <h1 class="h1 hero-title">
                    Home Cleaning Services <br>
                    with Zen.Home
                  </h1>
                  <p class="hero-text">
                    Expert cleaning services customized for your home.
                  </p>
                  <p class="price">Starting from $16/hr</p>
                  <a href="#service" class="btn btn-primary">Book a Service</a>
                </div>
              </div>
            </li>

            <li class="scrollbar-item">
              <div class="hero-card has-bg-image" style="background-image: url('../img/hero-banner-1.jpg')">
                <div class="card-content">
                  <h1 class="h1 hero-title">
                    Office Cleaning Services <br>
                    with Zen.Home
                  </h1>
                  <p class="hero-text">
                    Professional cleaning for a healthier workplace.
                  </p>
                  <p class="price">Starting from $18/hr</p>
                  <a href="#" class="btn btn-primary">Book a Service</a>
                </div>
              </div>
            </li>

            <li class="scrollbar-item">
              <div class="hero-card has-bg-image" style="background-image: url('../img/hero-banner-3.jpg')">
                <div class="card-content">
                  <h1 class="h1 hero-title">
                    Specialized Cleaning Services <br>
                    with Zen.Home
                  </h1>
                  <p class="hero-text">
                    Specialized solutions for your specific cleaning needs.
                  </p>
                  <p class="price">Starting from $20/hr</p>
                  <a href="#" class="btn btn-primary">Learn More</a>
                </div>
              </div>
            </li>

          </ul>

        </div>
      </section>

      <!-- 
        - #COLLECTION
      -->

      <section class="section collection" id="collection" aria-label="collection" data-section>
        <div class="container">
          <div class="title-wrapper" style="display: flex;
	          flex-wrap: wrap;
	    	  justify-content: space-between;
	    	  align-items: center;
	    	  gap: 18px;
	    	  margin-block-end: 50px;">
            <h2 class="h2 section-title">Categories</h2>

            <a href="viewCategory.jsp" class="btn-link">
              <span class="span">View All Categories</span>

              <ion-icon name="arrow-forward" aria-hidden="true"></ion-icon>
            </a>
          </div>

          <ul class="collection-list">
		      <%
		         CategoryDAO categoryDAO = new CategoryDAO();
		         List<Category> categories = categoryDAO.getCategories();
		         for (Category category : categories) {
		        	 int categoryID = category.getId();
		      %>
		        <li>
		          <div class="collection-card has-before hover:shine">
		            <h2 class="h2 card-title"><%= category.getName() %></h2>
		            <p class="card-text">Starting at $<%= categoryDAO.getLowestPriceByCategoryId(categoryID) %></p>
		            <a href="#" class="btn-link">
		              <span class="span">View Services</span>
		              <ion-icon name="arrow-forward" aria-hidden="true"></ion-icon>
		            </a>
		            <div class="has-bg-image" style="background-image: url('../<%= category.getImagePath() %>')"></div>
		          </div>
		        </li>
		      <%
		         }
		      %>
		    </ul>
        </div>
      </section>

      <!-- 
        - #SHOP
      -->

      <section class="section shop" id="service" aria-label="shop" data-section>
        <div class="container">

          <div class="title-wrapper">
            <h2 class="h2 section-title">Services</h2>

            <a href="viewCategory.jsp" class="btn-link">
              <span class="span">View All Services</span>

              <ion-icon name="arrow-forward" aria-hidden="true"></ion-icon>
            </a>
          </div>

          <ul class="has-scrollbar">
          <%
             ServiceDAO serviceDAO = new ServiceDAO();
             List<Service> services = serviceDAO.getAllServices();

             for (Service service : services) {
           %>
           <li class="scrollbar-item">
                    <div class="shop-card">
                        <div class="card-banner img-holder" style="--width: 540; --height: 720;">
                            <img src="../<%= service.getImagePath() %>" width="540" height="720" loading="lazy"
                                alt="<%= service.getServiceName() %>" class="img-cover">
                            <% if(service.getDiscount() > 0) { %>
                                <span class="badge" aria-label="<%= service.getDiscount() %> off">-<%= service.getDiscount() %>%</span>
                            <% } %>
                            <div class="card-actions">
                                <button class="action-btn" aria-label="add to cart">
                                    <ion-icon name="bag-handle-outline" aria-hidden="true"></ion-icon>
                                </button>
                                <button class="action-btn" aria-label="add to wishlist">
                                    <ion-icon name="star-outline" aria-hidden="true"></ion-icon>
                                </button>
                                <button class="action-btn" aria-label="compare">
                                    <ion-icon name="repeat-outline" aria-hidden="true"></ion-icon>
                                </button>
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="price">
                                <% if(service.getDiscount() > 0) { %>
                                    <del class="del">$<%= service.getPrice() %></del>
                                <% } %>
                                <span class="span">$<%= service.getPrice() * (1 - (service.getDiscount() / 100.0)) %></span>
                            </div>
                            <h3>
                                <a href="viewServiceDetails.jsp?serviceId=<%= service.getId()%>" class="card-title"><%= service.getServiceName() %></a>
                            </h3>
                            <div class="card-rating">
                                <div class="rating-wrapper" aria-label="5 start rating">
                               	   <% 
									   int rating = service.getServiceRating();
									   for (int i = 0; i < rating; i++) {
									   %>
									       <ion-icon name="star" aria-hidden="true"></ion-icon>
									   <% 
									   }
									   for (int i = rating; i < 5; i++) { 
									   %>
									       <ion-icon name="star-outline" aria-hidden="true"></ion-icon>
									   <% 
									   }
								   %>
                                </div>
                                <p class="rating-text">5170 reviews</p> <!-- Example static value -->
                            </div>
                        </div>
                    </div>
                </li>
          <% }%>
              </ul>
        </div>
      </section>


      <!-- 
        - #FEATURE
      -->
		
		<section class="section feature" aria-label="feature" data-section>
		  <div class="container">
		
		    <h2 class="h2-large section-title">Why Choose Zen.Home Cleaning Services?</h2>
		
		    <ul class="flex-list">
		
		      <li class="flex-item">
		        <div class="feature-card">
		          <img src="../img/feature-1.jpg" width="204" height="236" loading="lazy" alt="Eco-Friendly Cleaning"
		            class="card-icon">
		          <h3 class="h3 card-title">Eco-Friendly Cleaning</h3>
		          <p class="card-text">
		            We use environmentally friendly cleaning products that are safe for your family and pets.
		          </p>
		        </div>
		      </li>
		
		      <li class="flex-item">
		        <div class="feature-card">
		          <img src="../img/feature-2.jpg" width="204" height="236" loading="lazy"
		            alt="Trained Professionals" class="card-icon">
		          <h3 class="h3 card-title">Trained Professionals</h3>
		          <p class="card-text">
		            Our cleaners are professionally trained, ensuring top-notch service and meticulous attention to detail.
		          </p>
		        </div>
		      </li>
		
		      <li class="flex-item">
		        <div class="feature-card">
		          <img src="../img/feature-3.jpg" width="204" height="236" loading="lazy"
		            alt="Customized Services" class="card-icon">
		          <h3 class="h3 card-title">Customized Services</h3>
		          <p class="card-text">
		            Tailored cleaning plans to meet your specific needs, ensuring your home is spotless every time.
		          </p>
		        </div>
		      </li>
		
		    </ul>
		
		  </div>
		</section>


    </article>
  </main>
  <!-- 
    - #FOOTER
  -->
<%@ include file="footer.jsp"%>


  <!-- 
    - #BACK TO TOP
  -->

  <a href="#top" class="back-top-btn" aria-label="back to top" data-back-top-btn>
    <ion-icon name="arrow-up" aria-hidden="true"></ion-icon>
  </a>





  <!-- 
    - custom js link
  -->
  <script src="../js/home.js" defer></script>

  <!-- 
    - ionicon link
  -->
  <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
  <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

</body>
</html>