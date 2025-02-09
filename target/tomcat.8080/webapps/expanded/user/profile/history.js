
document.addEventListener('DOMContentLoaded', function() {
	
	setTimeout(function() {
	          var notification = document.querySelector('.notification');
	          if (notification) {
	              // Add fade-out class for opacity transition
	              notification.classList.add('fade-out');

	              // After the fade-out transition ends, completely remove the notification
	              notification.addEventListener('transitionend', function() {
	                  notification.style.display = 'none';  // Remove from layout
	              });
	          }
	      }, 5000); 
    window.currentRating = 0;
    
    // Make functions globally available
    window.openFeedbackModal = function(serviceId, serviceName, bookingId) {
        const modal = document.getElementById('feedback-modal');
        const modalContent = modal.querySelector('.modal');
        
        modal.style.display = 'block';
        setTimeout(() => modalContent.classList.add('active'), 10);
        
        document.getElementById('service-id').value = serviceId;
        document.getElementById('booking-id').value = bookingId;
        document.getElementById('service-name').innerHTML = `
            <i class="fas fa-concierge-bell"></i> ${serviceName}
        `;
        
        // Reset form
        currentRating = 0;
        updateStars();
        document.getElementById('feedback-comment').value = '';
    };

    window.closeFeedbackModal = function() {
        const modal = document.getElementById('feedback-modal');
        const modalContent = modal.querySelector('.modal');
        
        modalContent.classList.remove('active');
        setTimeout(() => {
            modal.style.display = 'none';
            document.getElementById('feedback-form').reset();
            currentRating = 0;
            updateStars();
        }, 300);
    };

    window.setRating = function(rating) {
        currentRating = rating;
        updateStars();
		document.getElementById("rating").value = currentRating;
        // Add animation to selected stars
        const stars = document.querySelectorAll('.star');
        stars.forEach((star, index) => {
            if (index < rating) {
                star.style.transform = 'scale(1.2)';
                setTimeout(() => {
                    star.style.transform = 'scale(1)';
                }, 200);
            }
        });
    };

    window.updateStars = function() {
        const stars = document.querySelectorAll('.star');
        stars.forEach((star, index) => {
            star.classList.toggle('active', index < currentRating);
            const starIcon = star.querySelector('i');
            if (index < currentRating) {
                starIcon.className = 'fas fa-star';
            } else {
                starIcon.className = 'far fa-star';
            }
        });
    };

	window.submitFeedback = function(event) {
	    event.preventDefault();

	    if (currentRating === 0) {
	        const errorMessage = document.createElement('div');
	        errorMessage.className = 'error-message';
	        errorMessage.innerHTML = '<i class="fas fa-exclamation-circle"></i> Please select a rating';
	        errorMessage.style.color = '#dc2626';
	        errorMessage.style.marginTop = '10px';
	        errorMessage.style.textAlign = 'center';

	        const existingError = document.querySelector('.error-message');
	        if (existingError) {
	            existingError.remove();
	        }

	        document.querySelector('.star-rating').after(errorMessage);

	        // Shake animation for stars
	        const starContainer = document.querySelector('.star-rating');
	        starContainer.style.animation = 'shake 0.5s ease-in-out';
	        setTimeout(() => {
	            starContainer.style.animation = '';
	        }, 500);

	        return;
	    }

	    // Create a form dynamically
	    const form = document.createElement('form');
	    form.method = 'POST';
	    form.action = 'submitFeedback.jsp';

	    // Append existing form data
	    const formData = new FormData(event.target);
	    formData.append('rating', currentRating);

	    formData.forEach((value, key) => {
	        const input = document.createElement('input');
	        input.type = 'hidden';
	        input.name = key;
	        input.value = value;
	        form.appendChild(input);
	    });

	    // Add loading state to the submit button
	    const submitBtn = event.target.querySelector('button[type="submit"]');
	    const originalContent = submitBtn.innerHTML;
	    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
	    submitBtn.disabled = true;

	    // Submit the form
	    document.body.appendChild(form);
	    form.submit();
	};

    // Add keydown event listener to close modal with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeFeedbackModal();
        }
    });

    // Close modal when clicking outside
    document.getElementById('feedback-modal').addEventListener('click', function(event) {
        if (event.target === this) {
            closeFeedbackModal();
        }
    });
});

// Add these keyframe animations to your CSS
const style = document.createElement('style');
style.textContent = `
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-10px); }
        75% { transform: translateX(10px); }
    }
    
    .star-rating {
        transition: transform 0.3s ease;
    }
`;
document.head.appendChild(style);
