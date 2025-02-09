<%@ page import="com.ca1.dao.ServiceDAO ,com.ca1.models.Service" %>
<%@ page import="java.util.ArrayList" %>
  <header class="header">

    <div class="alert">
      <div class="container">
        <p class="alert-text">10% DISCOUNT ON ALL SINGAPORE Orders $50+</p>
      </div>
    </div>

    <div class="header-top" data-header>
      <div class="container">

        <button class="nav-open-btn" aria-label="open menu" data-nav-toggler>
          <span class="line line-1"></span>
          <span class="line line-2"></span>
          <span class="line line-3"></span>
        </button>

        <div class="input-wrapper">
          <input type="search" name="search" placeholder="Search services" class="search-field">

          <button class="search-submit" aria-label="search">
            <ion-icon name="search-outline" aria-hidden="true"></ion-icon>
          </button>
        </div>

        <h2 class="logo_name">
          Zen.Home Cleaning
        </h2>

        <div class="header-actions">
        
	   <% 
	   Integer validSession = (Integer) session.getAttribute("userID");
	   if(validSession != null){ %>
	       <button onclick="window.location.href='profile/index.jsp'" class="header-action-btn" aria-label="user">
	           <ion-icon name="person-outline" aria-hidden="true"></ion-icon>
	       </button>
	   <% } else { %>
	        <button onclick="window.location.href='loginRegister.jsp'" class="header-action-btn" aria-label="cart item" style="display: flex">
	            <data class="btn-text" value="log-in">Log In</data>
	
	            <ion-icon name="log-in-outline" aria-hidden="true" aria-hidden="true"></ion-icon>
          </button>
	   <% } %>
       
          <button class="header-action-btn" aria-label="favourite item">
            <ion-icon name="star-outline" aria-hidden="true" aria-hidden="true"></ion-icon>

            <span class="btn-badge">0</span>
          </button>

<%
    // Retrieve the cart from the session
    ArrayList<Service> c = (ArrayList<Service>) session.getAttribute("cart");
    
    // If cart is null, initialize it as empty
    if (c == null) {
        c = new ArrayList<>();
    }

    // Calculate the number of items in the cart
    int cartItemCount = c.size();
%>

<!-- Cart Button -->
<button onclick="window.location.href='cart.jsp'" class="header-action-btn" aria-label="cart item">
  
    <ion-icon name="bag-handle-outline" aria-hidden="true"></ion-icon>

    <span class="btn-badge">
        <%= cartItemCount %> <!-- Display the cart size -->
    </span>
</button>


        </div>

        <nav class="navbar">
          <ul class="navbar-list">

            <li>
              <a href="home.jsp" class="navbar-link has-after">Home</a>
            </li>

            <li>
              <a href="viewCategory.jsp" class="navbar-link has-after">Categories</a>
            </li>

        

          </ul>
        </nav>

      </div>
    </div>

  </header>