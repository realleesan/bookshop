// Rating functionality JavaScript

let currentRating = 0;

// Open rating modal
function openRatingModal(productId, orderId, productTitle, productImg) {
    // Close order detail modal first before opening rating modal
    const orderDetailModal = document.querySelector('.modal.detail-order');
    if (orderDetailModal) {
        orderDetailModal.classList.remove('open');
    }
    
    const modal = document.querySelector('.rating-modal');
    document.getElementById('rating-product-id').value = productId;
    document.getElementById('rating-order-id').value = orderId;
    document.getElementById('rating-product-title').textContent = productTitle;
    document.getElementById('rating-product-img').src = productImg;
    document.getElementById('rating-comment').value = '';
    document.querySelector('.char-count').textContent = '0/300 ký tự';
    
    // Reset stars
    currentRating = 0;
    updateStars(0);
    document.getElementById('rating-value-text').textContent = '0/5 sao';
    
    modal.classList.add('open');
    document.body.style.overflow = 'hidden';
}

// Close rating modal
function closeRatingModal() {
    const modal = document.querySelector('.rating-modal');
    modal.classList.remove('open');
    document.body.style.overflow = 'auto';
}

// Update star display
function updateStars(rating) {
    const stars = document.querySelectorAll('.rating-stars .fa-star');
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.remove('fa-regular');
            star.classList.add('fa-solid');
            star.style.color = '#f39c12';
        } else {
            star.classList.remove('fa-solid');
            star.classList.add('fa-regular');
            star.style.color = '#ccc';
        }
    });
}

// Initialize star click handlers
document.addEventListener('DOMContentLoaded', function() {
    const stars = document.querySelectorAll('.rating-stars .fa-star');
    stars.forEach(star => {
        star.addEventListener('click', function() {
            currentRating = parseInt(this.getAttribute('data-rating'));
            updateStars(currentRating);
            document.getElementById('rating-value-text').textContent = currentRating + '/5 sao';
        });
        
        star.addEventListener('mouseover', function() {
            const hoverRating = parseInt(this.getAttribute('data-rating'));
            const stars = document.querySelectorAll('.rating-stars .fa-star');
            stars.forEach((s, index) => {
                if (index < hoverRating) {
                    s.style.color = '#f39c12';
                } else {
                    s.style.color = '#ccc';
                }
            });
        });
        
        star.addEventListener('mouseout', function() {
            updateStars(currentRating);
        });
    });
    
    // Character count for comment
    const commentBox = document.getElementById('rating-comment');
    if (commentBox) {
        commentBox.addEventListener('input', function() {
            const charCount = this.value.length;
            document.querySelector('.char-count').textContent = charCount + '/300 ký tự';
        });
    }
});

// Submit rating
function submitRating() {
    const productId = document.getElementById('rating-product-id').value;
    const orderId = document.getElementById('rating-order-id').value;
    const comment = document.getElementById('rating-comment').value;
    
    console.log('Rating submit - productId:', productId, 'orderId:', orderId, 'rating:', currentRating);
    console.log('Hidden input values - product:', document.getElementById('rating-product-id').value, 'order:', document.getElementById('rating-order-id').value);
    
    // Validate productId and orderId
    if (!productId || productId === '' || productId === 'undefined') {
        toast({ title: 'Error', message: 'Thiếu thông tin sản phẩm!', type: 'error', duration: 3000 });
        return;
    }
    
    if (!orderId || orderId === '' || orderId === 'undefined') {
        toast({ title: 'Error', message: 'Thiếu thông tin đơn hàng!', type: 'error', duration: 3000 });
        return;
    }
    
    if (currentRating === 0) {
        toast({ title: 'Warning', message: 'Vui lòng chọn số sao đánh giá!', type: 'warning', duration: 3000 });
        return;
    }
    
    // Get user from localStorage
    let user = localStorage.getItem('currentuser');
    console.log('User from localStorage:', user);
    
    if (!user) {
        toast({ title: 'Warning', message: 'Vui lòng đăng nhập để đánh giá!', type: 'warning', duration: 3000 });
        return;
    }
    
    user = JSON.parse(user);
    console.log('Parsed user object:', user);
    
    // Handle user_id - use id if available, otherwise use phone as fallback
    const userId = user.id || user.phone;
    const userFullname = user.fullname || '';
    
    // Handle order_id - extract numeric part from "DH1" format
    const orderIdNum = orderId.replace('DH', '');
    
    const ratingData = {
        product_id: parseInt(productId),
        user_id: userId,
        user_fullname: userFullname,
        order_id: orderIdNum,
        rating: currentRating,
        comment: comment
    };
    
    console.log('Sending rating data:', ratingData);
    
    fetch('api/rating.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(ratingData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            toast({ title: 'Success', message: data.message, type: 'success', duration: 3000 });
            closeRatingModal();
            // Refresh the order details to update the rating button
            detailOrder(orderId);
            // Also reload the product reviews if the product detail modal is open
            if (productId) {
                loadProductReviews(productId);
            }
        } else if (data.message.includes('đã được đánh giá')) {
            toast({ title: 'Error', message: data.message, type: 'error', duration: 3000 });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        toast({ title: 'Error', message: 'Đã xảy ra lỗi khi gửi đánh giá!', type: 'error', duration: 3000 });
    });
}

// Get ratings for a product
function getProductRatings(productId, callback) {
    console.log('Fetching ratings for product_id:', productId);
    fetch('api/rating.php?product_id=' + productId)
    .then(response => {
        console.log('Response status:', response.status);
        return response.text();
    })
    .then(text => {
        console.log('Raw response:', text);
        const data = JSON.parse(text);
        console.log('Ratings API response:', data);
        if (data.success) {
            callback(data);
        } else {
            callback(null);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        callback(null);
    });
}

// Load and display product reviews
function loadProductReviews(productId) {
    const reviewsContainer = document.getElementById('product-reviews-' + productId);
    if (!reviewsContainer) return;
    
    getProductRatings(productId, function(data) {
        if (!data) {
            reviewsContainer.innerHTML = '<div class="no-reviews">Chưa có đánh giá nào</div>';
            return;
        }
        
        const { ratings, average_rating, total_ratings } = data;
        
        if (total_ratings === 0) {
            reviewsContainer.innerHTML = '<div class="no-reviews">Chưa có đánh giá nào</div>';
            return;
        }
        
        let reviewsHtml = `
            <h3 class="product-reviews-title">Đánh giá sản phẩm</h3>
            <div class="reviews-summary">
                <span class="avg-rating">${average_rating}</span>
                <div class="rating-details">
                    <div class="review-stars">
                        ${getStarDisplay(average_rating)}
                    </div>
                    <span class="total-reviews">${total_ratings} đánh giá</span>
                </div>
            </div>
        `;
        
        ratings.forEach(review => {
            const date = new Date(review.created_at).toLocaleDateString('vi-VN');
            reviewsHtml += `
                <div class="review-item">
                    <div class="review-header">
                        <span class="reviewer-name">${review.display_name || 'Ẩn danh'}</span>
                        <span class="review-date">${date}</span>
                    </div>
                    <div class="review-stars">${getStarDisplay(review.rating)}</div>
                    ${review.comment ? `<p class="review-comment">${review.comment}</p>` : ''}
                </div>
            `;
        });
        
        reviewsContainer.innerHTML = reviewsHtml;
    });
}

// Get star display HTML
function getStarDisplay(rating) {
    let stars = '';
    for (let i = 1; i <= 5; i++) {
        if (i <= rating) {
            stars += '<i class="fa-solid fa-star"></i>';
        } else if (i - 0.5 <= rating) {
            stars += '<i class="fa-solid fa-star-half-stroke"></i>';
        } else {
            stars += '<i class="fa-regular fa-star"></i>';
        }
    }
    return stars;
}

// Load reviews when product detail modal opens
const originalDetailProduct = window.detailProduct;
if (typeof originalDetailProduct === 'function') {
    window.detailProduct = function(index) {
        originalDetailProduct(index);
        // Load reviews after modal opens
        setTimeout(() => {
            loadProductReviews(index);
        }, 100);
    };
}
