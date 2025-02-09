<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Inquiry</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/admin/index.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/admin/sale/index.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <%@ include file="../sidebar.jsp" %>

    <div class="content">
        <h1>Sales Inquiry</h1>
        
        <!-- Original search forms -->
        <form id="salesForm">
            <div class="form-group">
                <label for="date">By Date:</label>
                <input type="date" id="date" name="date">
                <button type="button" onclick="fetchByDate()">Search</button>
            </div>
            <div class="form-group">
                <label for="startDate">By Period:</label>
                <input type="date" id="startDate" name="startDate">
                <input type="date" id="endDate" name="endDate">
                <button type="button" onclick="fetchByPeriod()">Search</button>
            </div>
            <div class="form-group">
                <label for="month">By Month and Year:</label>
                <input type="number" id="month" name="month" placeholder="Month (1-12)">
                <input type="number" id="year" name="year" placeholder="Year">
                <button type="button" onclick="fetchByMonth()">Search</button>
            </div>
        </form>

        <!-- Top 10 Customers Section -->
        <div class="section">
            <h2>Top 10 Customers by Booking Value</h2>
            <button type="button" onclick="fetchTop10Customers()">View Top Customers</button>
            <div id="top10Results"></div>
        </div>

        <!-- Customers by Service Section -->
        <div class="section">
            <h2>Customers by Cleaning Service</h2>
            <button type="button" onclick="fetchCustomersByService()">View Service Customers</button>
            <div id="serviceResults"></div>
        </div>

        <!-- Original results div -->
        <div id="results"></div>
    </div>

    <script>
        function fetchByDate() {
            const date = document.getElementById('date').value;
            if (!date) {
                alert("Please select a valid date.");
                return;
            }
            $.ajax({
                url: '<%= request.getContextPath() %>/api/sales/date/' + date,
                method: 'GET',
                success: function(data) {
                    console.log(data);
                    displayResults(data);
                },
                error: function() {
                    alert("Error fetching data.");
                }
            });
        }

        function fetchByPeriod() {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            if (!startDate || !endDate) {
                alert("Please select both start and end dates.");
                return;
            }
            $.ajax({
                url: '<%= request.getContextPath() %>/api/sales/period/' + startDate + '/' + endDate,
                method: 'GET',
                success: function(data) {
                    displayResults(data);
                },
                error: function() {
                    alert("Error fetching data.");
                }
            });
        }

        function fetchByMonth() {
            const month = document.getElementById('month').value;
            const year = document.getElementById('year').value;
            if (!month || !year) {
                alert("Please enter both month and year.");
                return;
            }
            $.ajax({
                url: '<%= request.getContextPath() %>/api/sales/monthYear/' + month + '/' + year,
                method: 'GET',
                success: function(data) {
                    console.log(data);
                    displayResults(data);
                },
                error: function() {
                    alert("Error fetching data.");
                }
            });
        }

        function displayResults(data) {
            const resultsDiv = document.getElementById('results');
            resultsDiv.textContent = ''; // Clear previous results

            if (data.length === 0) {
                const noResults = document.createElement('p');
                noResults.textContent = 'No results found.';
                resultsDiv.appendChild(noResults);
                return;
            }

            const table = document.createElement('table');
            table.style.width = '100%';
            table.style.borderCollapse = 'collapse';

            const thead = document.createElement('thead');
            const headerRow = document.createElement('tr');
            const headers = ['Booking ID', 'Customer ID', 'Booking Date', 'Status', 'Total Price'];

            headers.forEach(headerText => {
                const th = document.createElement('th');
                th.textContent = headerText;
                th.style.border = '1px solid #ddd';
                th.style.padding = '8px';
                th.style.backgroundColor = '#f2f2f2';
                th.style.textAlign = 'left';
                headerRow.appendChild(th);
            });

            thead.appendChild(headerRow);
            table.appendChild(thead);

            const tbody = document.createElement('tbody');

            data.forEach(sale => {
                const row = document.createElement('tr');
                row.style.cursor = 'pointer';
                row.style.border = '1px solid #ddd';
                row.style.padding = '8px';

                row.addEventListener('click', () => {
                    
                     window.location.href = '<%= request.getContextPath() %>/admin/bookingdetail/index.jsp?bookingId='+ sale.bookingId; 
                });

                const bookingId = document.createElement('td');
                bookingId.textContent = sale.bookingId;

                const customerId = document.createElement('td');
                customerId.textContent = sale.customerId;

                const bookingDate = document.createElement('td');
                bookingDate.textContent = formatDate(sale.bookingDate);

                const status = document.createElement('td');
                status.textContent = sale.status;

                const totalPrice = document.createElement('td');
                totalPrice.textContent = '$' + sale.totalPrice.toFixed(2);

                row.append(bookingId, customerId, bookingDate, status, totalPrice);
                tbody.appendChild(row);
            });

            table.appendChild(tbody);
            resultsDiv.appendChild(table);
        }

        function formatDate(date) {
            const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
            return new Date(date).toLocaleDateString(undefined, options);
        }

        function fetchTop10Customers() {
            $.ajax({
                url: '<%= request.getContextPath() %>/GetTop10BookingsByValue',
                method: 'GET',
                success: function(data) {
                	console.log(data)
                    displayTop10Customers(data);
                },
                error: function() {
                    alert("Error fetching top customers data.");
                }
            });
        }

        function displayTop10Customers(data) {
            const resultsDiv = document.getElementById('top10Results');
            resultsDiv.textContent = '';

            if (data.length === 0) {
                resultsDiv.textContent = 'No results found.';
                return;
            }

            const table = document.createElement('table');
            const thead = document.createElement('thead');
            thead.innerHTML = `
                <tr>
                    <th>Rank</th>
                    <th>Customer ID</th>
                    <th>Username</th>
                    <th>Total Spent</th>
                </tr>
            `;
            table.appendChild(thead);

            const tbody = document.createElement('tbody');
            data.forEach((customer, index) => {
                const row = document.createElement('tr');

                const rank = document.createElement('td');
                rank.textContent = index + 1;

                const customerId = document.createElement('td');
                customerId.textContent = customer.id;

                const name = document.createElement('td');
                name.textContent = customer.name;

                const totalSpent = document.createElement('td');
                totalSpent.textContent = '$' + customer.totalSpent.toFixed(2);

                row.append(rank, customerId, name, totalSpent);
                tbody.appendChild(row);
            });

            table.appendChild(tbody);
            resultsDiv.appendChild(table);
        }

        function fetchCustomersByService() {
            $.ajax({
                url: '<%= request.getContextPath() %>/GetCustomersForCleaningServices',
                method: 'GET',
                success: function(data) {
                	console.log(data)
                    displayCustomersByService(data);
                },
                error: function() {
                    alert("Error fetching service customer data.");
                }
            });
        }

        function displayCustomersByService(data) {
            const resultsDiv = document.getElementById('serviceResults');
            resultsDiv.textContent = ''; // Clear previous results

            if (Object.keys(data).length === 0) {
                resultsDiv.textContent = 'No results found.';
                return;
            }

            // Loop through each service and its customers
            Object.entries(data).forEach(([serviceName, customers]) => {
                const serviceSection = document.createElement('div');
                serviceSection.className = 'service-section';

                const serviceHeader = document.createElement('h3');
                serviceHeader.textContent = serviceName;
                serviceSection.appendChild(serviceHeader);

                const table = document.createElement('table');
                table.innerHTML = `
                    <thead>
                        <tr>
                            <th>Customer ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Quantity</th>
                            <th>Total Spent</th>
                            <th>Booking Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                `;

                const tbody = table.querySelector('tbody');

                // Loop through the customers for this service
                customers.forEach(customer => {
                    const row = document.createElement('tr');

                    const customerId = document.createElement('td');
                    customerId.textContent = customer.id;

                    const name = document.createElement('td');
                    name.textContent = customer.name;

                    const email = document.createElement('td');
                    email.textContent = customer.email;

                    const phone = document.createElement('td');
                    phone.textContent = customer.phone || 'N/A';

                    const quantity = document.createElement('td');
                    quantity.textContent = customer.quantity;

                    const totalSpent = document.createElement('td');
                    totalSpent.textContent = '$' + customer.totalSpent.toFixed(2);

                    const bookingDate = document.createElement('td');
                    bookingDate.textContent = formatDate(customer.bookingDate);

                    const status = document.createElement('td');
                    status.textContent = customer.status;

                    row.append(customerId, name, email, phone, quantity, totalSpent, bookingDate, status);
                    tbody.appendChild(row);
                });

                serviceSection.appendChild(table);
                resultsDiv.appendChild(serviceSection);
            });
        }

    </script>
</body>
</html>
