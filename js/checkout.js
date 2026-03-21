const PHIVANCHUYEN = 30000;
let priceFinal = document.getElementById("checkout-cart-price-final");

// Coupon system variables
let appliedCoupon = null;
let discountAmount = 0;
let currentCheckoutOption = 1; // 1 = cart, 2 = single product
let currentCheckoutProduct = null; // product data for single product checkout

// Function to calculate total with shipping
function getTotalWithShipping() {
    // Use stored checkout option to determine total
    if (currentCheckoutOption === 2 && currentCheckoutProduct) {
        // Single product checkout
        return currentCheckoutProduct.soluong * currentCheckoutProduct.price + PHIVANCHUYEN;
    }
    // Cart checkout
    return getCartTotal() + PHIVANCHUYEN;
}

// Function to apply coupon discount
function applyCouponDiscount() {
    let couponInput = document.getElementById('coupon-code');
    let couponMessage = document.getElementById('coupon-message');
    let discountDisplay = document.getElementById('discount-display');
    let discountAmountEl = document.getElementById('discount-amount');
    
    let code = couponInput.value.trim();
    
    // Validate input
    if (code === '') {
        couponMessage.textContent = 'Vui lòng nhập mã giảm giá!';
        couponMessage.className = 'coupon-message error';
        return;
    }
    
    if (!/^\d{6}$/.test(code)) {
        couponMessage.textContent = 'Mã giảm giá phải là 6 chữ số!';
        couponMessage.className = 'coupon-message error';
        return;
    }
    
    // Call API to validate coupon
    let formData = new FormData();
    formData.append('action', 'validate');
    formData.append('code', code);
    
    fetch('api/coupon.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success && data.valid) {
            // Coupon is valid
            appliedCoupon = code;
            let discountPercent = data.discount_percent;
            
            // Calculate discount amount
            let total = getTotalWithShipping();
            discountAmount = total * (discountPercent / 100);
            
            // Update UI
            couponMessage.textContent = data.message;
            couponMessage.className = 'coupon-message success';
            discountDisplay.style.display = 'flex';
            discountAmountEl.textContent = '-' + vnd(discountAmount);
            
            // Update total price
            let newTotal = total - discountAmount;
            priceFinal.innerText = vnd(newTotal);
            
            // Store discount info for order
            localStorage.setItem('appliedCoupon', JSON.stringify({
                code: code,
                discountPercent: discountPercent,
                discountAmount: discountAmount
            }));
        } else {
            // Coupon is invalid
            couponMessage.textContent = data.message;
            couponMessage.className = 'coupon-message error';
            discountDisplay.style.display = 'none';
            appliedCoupon = null;
            discountAmount = 0;
            
            // Reset total price
            let total = getTotalWithShipping();
            priceFinal.innerText = vnd(total);
            localStorage.removeItem('appliedCoupon');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        couponMessage.textContent = 'Có lỗi xảy ra. Vui lòng thử lại!';
        couponMessage.className = 'coupon-message error';
    });
}

// Add event listener for apply coupon button
document.addEventListener('DOMContentLoaded', function() {
    let applyBtn = document.getElementById('apply-coupon-btn');
    if (applyBtn) {
        applyBtn.addEventListener('click', applyCouponDiscount);
    }
    
    // Allow pressing Enter to apply coupon
    let couponInput = document.getElementById('coupon-code');
    if (couponInput) {
        couponInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                applyCouponDiscount();
            }
        });
    }
});
// Trang thanh toan
function thanhtoanpage(option,product) {
    // Store checkout option for coupon calculation
    currentCheckoutOption = option;
    currentCheckoutProduct = product || null;
    
    // Reset coupon when opening checkout
    appliedCoupon = null;
    discountAmount = 0;
    localStorage.removeItem('appliedCoupon');
    let couponInput = document.getElementById('coupon-code');
    let couponMessage = document.getElementById('coupon-message');
    let discountDisplay = document.getElementById('discount-display');
    if (couponInput) couponInput.value = '';
    if (couponMessage) couponMessage.textContent = '';
    if (discountDisplay) discountDisplay.style.display = 'none';
    // Xu ly ngay nhan hang
    let today = new Date();
    let ngaymai = new Date();
    let ngaykia = new Date();
    ngaymai.setDate(today.getDate() + 1);
    ngaykia.setDate(today.getDate() + 2);
    let dateorderhtml = `<a href="javascript:;" class="pick-date active" data-date="${today}">
        <span class="text">Hôm nay</span>
        <span class="date">${today.getDate()}/${today.getMonth() + 1}</span>
        </a>
        <a href="javascript:;" class="pick-date" data-date="${ngaymai}">
            <span class="text">Ngày mai</span>
            <span class="date">${ngaymai.getDate()}/${ngaymai.getMonth() + 1}</span>
        </a>

        <a href="javascript:;" class="pick-date" data-date="${ngaykia}">
            <span class="text">Ngày kia</span>
            <span class="date">${ngaykia.getDate()}/${ngaykia.getMonth() + 1}</span>
    </a>`
    document.querySelector('.date-order').innerHTML = dateorderhtml;
    let pickdate = document.getElementsByClassName('pick-date')
    for(let i = 0; i < pickdate.length; i++) {
        pickdate[i].onclick = function () {
            document.querySelector(".pick-date.active").classList.remove("active");
            this.classList.add('active');
        }
    }

    let totalBillOrder = document.querySelector('.total-bill-order');
    let totalBillOrderHtml;
    // Xu ly don hang
    switch (option) {
        case 1: // Truong hop thanh toan san pham trong gio
            // Hien thi don hang
            showProductCart();
            // Tinh tien
            totalBillOrderHtml = `<div class="priceFlx">
            <div class="text">
                Tiền hàng 
                <span class="count">${getAmountCart()} sách</span>
            </div>
            <div class="price-detail">
                <span id="checkout-cart-total">${vnd(getCartTotal())}</span>
            </div>
        </div>
        <div class="priceFlx chk-ship">
            <div class="text">Phí vận chuyển</div>
            <div class="price-detail chk-free-ship">
                <span>${vnd(PHIVANCHUYEN)}</span>
            </div>
        </div>`;
            // Tong tien
            priceFinal.innerText = vnd(getCartTotal() + PHIVANCHUYEN);
            break;
        case 2: // Truong hop mua ngay
            // Hien thi san pham
            showProductBuyNow(product);
            // Tinh tien
            totalBillOrderHtml = `<div class="priceFlx">
                <div class="text">
                    Tiền hàng 
                    <span class="count">${product.soluong} sách</span>
                </div>
                <div class="price-detail">
                    <span id="checkout-cart-total">${vnd(product.soluong * product.price)}</span>
                </div>
            </div>
            <div class="priceFlx chk-ship">
                <div class="text">Phí vận chuyển</div>
                <div class="price-detail chk-free-ship">
                    <span>${vnd(PHIVANCHUYEN)}</span>
                </div>
            </div>`
            // Tong tien
            priceFinal.innerText = vnd((product.soluong * product.price) + PHIVANCHUYEN);
            break;
    }

    // Tinh tien
    totalBillOrder.innerHTML = totalBillOrderHtml;

    // Xu ly hinh thuc giao hang
    let giaotannoi = document.querySelector('#giaotannoi');
    let tudenlay = document.querySelector('#tudenlay');
    let tudenlayGroup = document.querySelector('#tudenlay-group');
    let chkShip = document.querySelectorAll(".chk-ship");
    
    tudenlay.addEventListener('click', () => {
        giaotannoi.classList.remove("active");
        tudenlay.classList.add("active");
        chkShip.forEach(item => {
            item.style.display = "none";
        });
        tudenlayGroup.style.display = "block";
        
        // Calculate total without shipping for pickup
        let total = 0;
        if (currentCheckoutOption === 2 && currentCheckoutProduct) {
            total = currentCheckoutProduct.soluong * currentCheckoutProduct.price;
        } else {
            total = getCartTotal();
        }
        
        // Apply coupon discount if exists
        if (appliedCoupon && discountAmount > 0) {
            // Recalculate discount for new total (without shipping)
            let newDiscountAmount = total * 0.1; // 10%
            discountAmount = newDiscountAmount;
            priceFinal.innerText = vnd(total - newDiscountAmount);
            
            // Update stored coupon info
            localStorage.setItem('appliedCoupon', JSON.stringify({
                code: appliedCoupon,
                discountPercent: 10,
                discountAmount: newDiscountAmount
            }));
            
            // Update discount display
            let discountAmountEl = document.getElementById('discount-amount');
            if (discountAmountEl) discountAmountEl.textContent = '-' + vnd(newDiscountAmount);
        } else {
            priceFinal.innerText = vnd(total);
        }
    })

    giaotannoi.addEventListener('click', () => {
        tudenlay.classList.remove("active");
        giaotannoi.classList.add("active");
        tudenlayGroup.style.display = "none";
        chkShip.forEach(item => {
            item.style.display = "flex";
        });
        
        // Calculate total with shipping for delivery
        let total = getTotalWithShipping();
        
        // Apply coupon discount if exists
        if (appliedCoupon && discountAmount > 0) {
            // Recalculate discount for new total (with shipping)
            let newDiscountAmount = total * 0.1; // 10%
            discountAmount = newDiscountAmount;
            priceFinal.innerText = vnd(total - newDiscountAmount);
            
            // Update stored coupon info
            localStorage.setItem('appliedCoupon', JSON.stringify({
                code: appliedCoupon,
                discountPercent: 10,
                discountAmount: newDiscountAmount
            }));
            
            // Update discount display
            let discountAmountEl = document.getElementById('discount-amount');
            if (discountAmountEl) discountAmountEl.textContent = '-' + vnd(newDiscountAmount);
        } else {
            priceFinal.innerText = vnd(total);
        }
    })

    // Su kien khu nhan nut dat hang
    document.querySelector(".complete-checkout-btn").onclick = () => {
        switch (option) {
            case 1:
                xulyDathang();
                break;
            case 2:
                xulyDathang(product);
                break;
        }
    }
}

// Hien thi hang trong gio
function showProductCart() {
    let currentuser = JSON.parse(localStorage.getItem('currentuser'));
    let listOrder = document.getElementById("list-order-checkout");
    let listOrderHtml = '';
    currentuser.cart.forEach(item => {
        let product = getProduct(item);
        listOrderHtml += `<div class="book-total">
        <div class="count">${product.soluong}x</div>
        <div class="info-book">
            <div class="name-book">${product.title}</div>
        </div>
    </div>`
    })
    listOrder.innerHTML = listOrderHtml;
}

// Hien thi hang mua ngay
function showProductBuyNow(product) {
    let listOrder = document.getElementById("list-order-checkout");
    let listOrderHtml = `<div class="book-total">
        <div class="count">${product.soluong}x</div>
        <div class="info-book">
            <div class="name-book">${product.title}</div>
        </div>
    </div>`;
    listOrder.innerHTML = listOrderHtml;
}

//Open Page Checkout
let nutthanhtoan = document.querySelector('.thanh-toan')
let checkoutpage = document.querySelector('.checkout-page');
nutthanhtoan.addEventListener('click', () => {
    checkoutpage.classList.add('active');
    thanhtoanpage(1);
    closeCart();
    body.style.overflow = "hidden"
})

// Đặt hàng ngay
function dathangngay() {
    let productInfo = document.getElementById("product-detail-content");
    let datHangNgayBtn = productInfo.querySelector(".button-dathangngay");
    datHangNgayBtn.onclick = () => {
        if(!localStorage.getItem('currentuser')) {
            toast({ title: 'Warning', message: 'Vui lòng đăng nhập để mua hàng!', type: 'warning', duration: 3000 });
            // Open login modal
            let formsg = document.querySelector('.modal.signup-login');
            let container = document.querySelector('.signup-login .modal-container');
            formsg.classList.add('open');
            container.classList.add('active');
            return;
        }
        
        let productId = datHangNgayBtn.getAttribute("data-product");
        let soluong = parseInt(productInfo.querySelector(".buttons_added .input-qty").value);
        let notevalue = productInfo.querySelector("#popup-detail-note").value;
        let ghichu = notevalue == "" ? "Không có ghi chú" : notevalue;
        let products = JSON.parse(localStorage.getItem('products'));
        let a = products.find(item => item.id == productId);
        a.soluong = parseInt(soluong);
        a.note = ghichu;
        checkoutpage.classList.add('active');
        thanhtoanpage(2,a);
        closeCart();
        let modal = document.querySelector('.modal.product-detail');
        modal.classList.remove('open');
        body.style.overflow = "hidden"
    }
}

// Close Page Checkout
function closecheckout() {
    checkoutpage.classList.remove('active');
    body.style.overflow = "auto"
}

// Thong tin cac don hang da mua - Xu ly khi nhan nut dat hang
async function xulyDathang(product) {
    let diachinhan = "";
    let hinhthucgiao = "";
    let thoigiangiao = "";
    let giaotannoi = document.querySelector("#giaotannoi");
    let tudenlay = document.querySelector("#tudenlay");
    let giaongay = document.querySelector("#giaongay");
    let giaovaogio = document.querySelector("#deliverytime");
    let currentUser = JSON.parse(localStorage.getItem('currentuser'));
    
    // Hình thức giao & Địa chỉ nhận hàng
    if(giaotannoi.classList.contains("active")) {
        diachinhan = document.querySelector("#diachinhan").value;
        hinhthucgiao = giaotannoi.innerText;
    }
    if(tudenlay.classList.contains("active")){
        let chinhanh1 = document.querySelector("#chinhanh-1");
        let chinhanh2 = document.querySelector("#chinhanh-2");
        
        // Validate branch selection
        if(!chinhanh1.checked && !chinhanh2.checked) {
            toast({ title: 'Chú ý', message: 'Vui lòng chọn chi nhánh để lấy hàng!', type: 'warning', duration: 4000 });
            return;
        }
        
        if(chinhanh1.checked) {
            diachinhan = "Phường Từ Liêm, TP Hà Nội";
        }
        if(chinhanh2.checked) {
            diachinhan = "Quận Gò Vấp, Thành phố Hồ Chí Minh";
        }
        hinhthucgiao = tudenlay.innerText;
    }

    // Thời gian nhận hàng (chỉ áp dụng cho giao tận nơi)
    if(tudenlay.classList.contains("active")) {
        // Với hình thức tự đến lấy, không cần chọn thời gian giao
        thoigiangiao = "Đến lấy tại cửa hàng";
    } else {
        // Với hình thức giao tận nơi, bắt buộc chọn thời gian
        if(giaongay.checked) {
            thoigiangiao = "Giao ngay khi xong";
        } else if(giaovaogio.checked) {
            thoigiangiao = document.querySelector(".choise-time").value;
        }
        
        // Validate delivery time selection
        if (thoigiangiao === "") {
            toast({ title: 'Chú ý', message: 'Vui lòng chọn thời gian giao hàng!', type: 'warning', duration: 4000 });
            return;
        }
    }

    let orderDetails = localStorage.getItem("orderDetails") ? JSON.parse(localStorage.getItem("orderDetails")) : [];
    let order = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];
    let madon = createId(order);
    let tongtien = 0;
    let phiVanChuyen = 0;
    let giamGia = 0;
    
    // Handle product(s)
    if(product == undefined) {
        if (currentUser && currentUser.cart) {
            currentUser.cart.forEach(item => {
                item.madon = madon;
                item.price = getpriceProduct(item.id);
                tongtien += item.price * item.soluong;
                orderDetails.push(item);
            });
        }
    } else {
        product.madon = madon;
        product.price = getpriceProduct(product.id);
        tongtien += product.price * product.soluong;
        orderDetails.push(product);
    }
    
    // Add shipping fee if delivery is selected (not pickup)
    if(tudenlay && !tudenlay.classList.contains("active")) {
        // Delivery option - add shipping fee
        phiVanChuyen = PHIVANCHUYEN;
    }
    
    // Apply coupon discount if available
    let couponData = localStorage.getItem('appliedCoupon');
    if(couponData) {
        let coupon = JSON.parse(couponData);
        giamGia = coupon.discountAmount || 0;
    }
    
    // Calculate total with shipping and discount
    let tongtienSauGiam = tongtien + phiVanChuyen - giamGia;   
    
    let tennguoinhan = document.querySelector("#tennguoinhan").value.trim();
    let sdtnhan = document.querySelector("#sdtnhan").value.trim();
    
    // Chỉ lấy địa chỉ từ input khi chọn giao tận nơi
    if(giaotannoi.classList.contains("active")) {
        diachinhan = document.querySelector("#diachinhan").value.trim();
    }
    
    // Validate receiver name (only letters, minimum 3 characters)
    let nameRegex = /^[a-zA-ZÀ-ỹ\s]+$/;
    if (tennguoinhan === "") {
        toast({ title: 'Chú ý', message: 'Vui lòng nhập tên người nhận!', type: 'warning', duration: 4000 });
        return;
    } else if (tennguoinhan.length < 3) {
        toast({ title: 'Lỗi', message: 'Tên người nhận phải có ít nhất 3 ký tự!', type: 'error', duration: 4000 });
        return;
    } else if (!nameRegex.test(tennguoinhan)) {
        toast({ title: 'Lỗi', message: 'Tên người nhận chỉ được chứa chữ cái!', type: 'error', duration: 4000 });
        return;
    }
    
    // Validate phone (exactly 10 digits)
    let phoneRegex = /^\d{10}$/;
    if (sdtnhan === "") {
        toast({ title: 'Chú ý', message: 'Vui lòng nhập số điện thoại!', type: 'warning', duration: 4000 });
        return;
    } else if (!phoneRegex.test(sdtnhan)) {
        toast({ title: 'Lỗi', message: 'Số điện thoại phải là 10 chữ số!', type: 'error', duration: 4000 });
        return;
    }
    
    // Validate address (minimum 6 characters) - chỉ áp dụng khi giao tận nơi
    if(giaotannoi.classList.contains("active")) {
        if (diachinhan === "") {
            toast({ title: 'Chú ý', message: 'Vui lòng nhập địa chỉ giao hàng!', type: 'warning', duration: 4000 });
            return;
        } else if (diachinhan.length < 6) {
            toast({ title: 'Lỗi', message: 'Địa chỉ phải có ít nhất 6 ký tự!', type: 'error', duration: 4000 });
            return;
        }
    }
    
    // All validation passed - proceed with order
    {
        let donhang = {
            id: madon,
            khachhang: currentUser ? currentUser.phone : "Khách hàng đặt trực tiếp",
            hinhthucgiao: hinhthucgiao,
            ngaygiaohang: document.querySelector(".pick-date.active").getAttribute("data-date"),
            thoigiangiao: thoigiangiao,
            ghichu: document.querySelector(".note-order").value,
            tenguoinhan: tennguoinhan,
            sdtnhan: sdtnhan,
            diachinhan: diachinhan,
            thoigiandat: new Date(),
            tongtien: tongtienSauGiam,
            phiVanChuyen: phiVanChuyen,
            giamGia: giamGia,
            trangthai: 0
        }
    
        order.unshift(donhang);

        // Clear cart if user is logged in
        if(currentUser && currentUser.cart) {
            currentUser.cart.length = 0;
            localStorage.setItem("currentuser", JSON.stringify(currentUser));
        }
    
        localStorage.setItem("order", JSON.stringify(order));
        localStorage.setItem("orderDetails", JSON.stringify(orderDetails));

        toast({ title: 'Thành công', message: 'Đặt hàng thành công !', type: 'success', duration: 1000 });
        
        // Gửi dữ liệu đơn hàng và chi tiết đơn hàng đến server để lưu vào database
        //try {
            let formData = new FormData();
            formData.append('order', JSON.stringify(donhang));
            formData.append('orderDetails', JSON.stringify(orderDetails));

            const response = await fetch('add_order.php', {
                method: 'POST',
                body: formData
            });

            //const result = await response.json();
            //if (result.success) {
                //toast({ title: "Thành công", message: "Đơn hàng đã được thêm vào cơ sở dữ liệu!", type: "success", duration: 3000 });
            //} else {
                //toast({ title: "Lỗi", message: "Có lỗi xảy ra khi thêm đơn hàng vào cơ sở dữ liệu!", type: "error", duration: 3000 });
            //}
        

        // Mark coupon as used if applied
        let couponData = localStorage.getItem('appliedCoupon');
        if (couponData) {
            let coupon = JSON.parse(couponData);
            let formDataCoupon = new FormData();
            formDataCoupon.append('action', 'use');
            formDataCoupon.append('code', coupon.code);
            
            fetch('api/coupon.php', {
                method: 'POST',
                body: formDataCoupon
            }).then(() => {
                localStorage.removeItem('appliedCoupon');
            });
        }
        
        // Update sold count for each product in order
        orderDetails.forEach(item => {
            let formDataSold = new FormData();
            formDataSold.append('action', 'increment_sold');
            formDataSold.append('product_id', item.id);
            formDataSold.append('quantity', item.soluong);
            
            fetch('api/product_stats.php', {
                method: 'POST',
                body: formDataSold
            });
        });
        
        setTimeout((e) => {
            window.location.reload();
        }, 2000);  
    }
}


function getpriceProduct(id) {
    let products = JSON.parse(localStorage.getItem('products'));
    let sp = products.find(item => {
        return item.id == id;
    })
    return sp.price;
}