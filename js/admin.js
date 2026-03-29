function checkLogin() {
    let currentUser = JSON.parse(localStorage.getItem("currentuser"));
    if(currentUser == null || currentUser.userType == 0) {
        document.querySelector("body").innerHTML = `<div class="access-denied-section">
            <img class="access-denied-img" src="./assets/img/access-denied.webp" alt="">
        </div>`
    } else {
        document.getElementById("name-acc").innerHTML = currentUser.fullname;
    }
}
window.onload = checkLogin();

//do sidebar open and close
const menuIconButton = document.querySelector(".menu-icon-btn");
const sidebar = document.querySelector(".sidebar");
menuIconButton.addEventListener("click", () => {
    sidebar.classList.toggle("open");
});

// log out admin user
/*
let toogleMenu = document.querySelector(".profile");
let mune = document.querySelector(".profile-cropdown");
toogleMenu.onclick = function () {
    mune.classList.toggle("active");
};
*/

// tab for section
const sidebars = document.querySelectorAll(".sidebar-list-item.tab-content");
const sections = document.querySelectorAll(".section");

for(let i = 0; i < sidebars.length; i++) {
    sidebars[i].onclick = function () {
        document.querySelector(".sidebar-list-item.active").classList.remove("active");
        document.querySelector(".section.active").classList.remove("active");
        sidebars[i].classList.add("active");
        sections[i].classList.add("active");
        
        // Load users when clicking on users tab (2nd tab = index 2)
        if (i === 2) {
            loadUsersFromDB();
        }
        // Load orders when clicking on orders tab (3rd tab = index 3)
        if (i === 3) {
            loadOrdersFromDB();
        }
        // Load ratings when clicking on ratings tab (5th tab = index 5)
        if (i === 5) {
            loadRatings();
        }
    };
}

const closeBtn = document.querySelectorAll('.section');
console.log(closeBtn[0])
for(let i=0;i<closeBtn.length;i++){
    closeBtn[i].addEventListener('click',(e) => {
        sidebar.classList.add("open");
    })
}

// Get amount product
function getAmoumtProduct() {
    let products = localStorage.getItem("products") ? JSON.parse(localStorage.getItem("products")) : [];
    return products.length;
}

// Get amount user
function getAmoumtUser() {
    // Đếm TẤT CẢ người dùng (bao gồm cả admin và user)
    let accounts = localStorage.getItem("accounts") ? JSON.parse(localStorage.getItem("accounts")) : [];
    return accounts.length;
}

// Get amount user
function getMoney() {
    let tongtien = 0;
    let orders = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];
    orders.forEach(item => {
        tongtien += parseInt(item.tongtien) || 0;
    });
    return tongtien;
}

document.getElementById("amount-user").innerHTML = getAmoumtUser();
document.getElementById("amount-product").innerHTML = getAmoumtProduct();
document.getElementById("doanh-thu").innerHTML = vnd(getMoney());

// Doi sang dinh dang tien VND
function vnd(price) {
    if (price == null || price == undefined || isNaN(price)) {
        return '0 ₫';
    }
    return price.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
}
// Phân trang 
let perPage = 12;
let currentPage = 1;
let totalPage = 0;
let perProducts = [];

function displayList(productAll, perPage, currentPage) {
    let start = (currentPage - 1) * perPage;
    let end = (currentPage - 1) * perPage + perPage;
    let productShow = productAll.slice(start, end);
    showProductArr(productShow);
}

function setupPagination(productAll, perPage) {
    document.querySelector('.page-nav-list').innerHTML = '';
    let page_count = Math.ceil(productAll.length / perPage);
    for (let i = 1; i <= page_count; i++) {
        let li = paginationChange(i, productAll, currentPage);
        document.querySelector('.page-nav-list').appendChild(li);
    }
}

function paginationChange(page, productAll, currentPage) {
    let node = document.createElement(`li`);
    node.classList.add('page-nav-item');
    node.innerHTML = `<a href="#">${page}</a>`;
    if (currentPage == page) node.classList.add('active');
    node.addEventListener('click', function () {
        currentPage = page;
        displayList(productAll, perPage, currentPage);
        let t = document.querySelectorAll('.page-nav-item.active');
        for (let i = 0; i < t.length; i++) {
            t[i].classList.remove('active');
        }
        node.classList.add('active');
    })
    return node;
}

// Hiển thị danh sách sản phẩm 
function showProductArr(arr) {
    let productHtml = "";
    if(arr.length == 0) {
        productHtml = `<div class="no-result"><div class="no-result-i"><i class="fa-light fa-face-sad-cry"></i></div><div class="no-result-h">Không có sản phẩm để hiển thị</div></div>`;
    } else {
        arr.forEach(product => {
            // Always show delete button - no restore for deleted products
            let btnCtl = `<button class="btn-delete" onclick="deleteProduct(${product.id})"><i class="fa-regular fa-trash"></i></button>`;
            productHtml += `
            <div class="list">
                    <div class="list-left">
                    <img src="${product.img}" alt="">
                    <div class="list-info">
                        <h4>${product.title}</h4>
                        <p class="list-note">${product.desc}</p>
                        <span class="list-category">${product.category}</span>
                    </div>
                </div>
                <div class="list-right">
                    <div class="list-price">
                    <span class="list-current-price">${vnd(product.price)}</span>                   
                    </div>
                    <div class="list-control">
                    <div class="list-tool">
                        <button class="btn-edit" onclick="editProduct(${product.id})"><i class="fa-light fa-pen-to-square"></i></button>
                        ${btnCtl}
                    </div>                       
                </div>
                </div> 
            </div>`;
        });
    }
    document.getElementById("show-product").innerHTML = productHtml;
}

function showProduct() {
    let selectOp = document.getElementById('the-loai').value;
    let valeSearchInput = document.getElementById('form-search-product').value;
    let products = localStorage.getItem("products") ? JSON.parse(localStorage.getItem("products")) : [];

    if(selectOp == "Tất cả") {
        // Show all active products
        result = products;
    } else {
        result = products.filter((item) => item.category == selectOp);
    }

    result = valeSearchInput == "" ? result : result.filter(item => {
        return item.title.toString().toUpperCase().includes(valeSearchInput.toString().toUpperCase());
    })

    displayList(result, perPage, currentPage);
    setupPagination(result, perPage, currentPage);
}

function cancelSearchProduct() {
    let products = localStorage.getItem("products") ? JSON.parse(localStorage.getItem("products")).filter(item => item.status == 1) : [];
    document.getElementById('the-loai').value = "Tất cả";
    document.getElementById('form-search-product').value = "";
    displayList(products, perPage, currentPage);
    setupPagination(products, perPage, currentPage);
}

window.onload = showProduct();

function createId(arr) {
    let id = arr.length;
    let check = arr.find((item) => item.id == id);
    while (check != null) {
        id++;
        check = arr.find((item) => item.id == id);
    }
    return id;
}
// Xóa sản phẩm vĩnh viễn
function deleteProduct(id) {
    let products = JSON.parse(localStorage.getItem("products"));
    if (confirm("Bạn có chắc muốn xóa vĩnh viễn sản phẩm này? Hành động này không thể hoàn tác!") == true) {
        // Remove product from array (hard delete)
        products = products.filter(item => item.id != id);
        
        localStorage.setItem("products", JSON.stringify(products));
        
        // Gửi yêu cầu AJAX tới PHP để xóa vĩnh viễn khỏi database
        fetch('api/product_manage.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id: id, action: 'permanent_delete' })
        });
        
        toast({ title: 'Success', message: 'Xóa sản phẩm vĩnh viễn thành công !', type: 'success', duration: 3000 });
        showProduct();
    }
}

function changeStatusProduct(id) {
    let products = JSON.parse(localStorage.getItem("products"));
    let index = products.findIndex(item => {
        return item.id == id;
    })
    if (confirm("Bạn có chắc chắn muốn hủy xóa?") == true) {
        products[index].status = 1;
        
        toast({ title: 'Success', message: 'Khôi phục sản phẩm thành công !', type: 'success', duration: 3000 });
    }
    localStorage.setItem("products", JSON.stringify(products));
    // Gửi yêu cầu AJAX tới PHP để cập nhật database
    fetch('modify_product.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ id: id, action: 'restore' })
    });
    showProduct();
}

var indexCur;
function editProduct(id) {
    let products = localStorage.getItem("products") ? JSON.parse(localStorage.getItem("products")) : [];
    let index = products.findIndex(item => {
        return item.id == id;
    })
    indexCur = index;
    document.querySelectorAll(".add-product-e").forEach(item => {
        item.style.display = "none";
    })
    document.querySelectorAll(".edit-product-e").forEach(item => {
        item.style.display = "block";
    })
    document.querySelector(".add-product").classList.add("open");
    //
    document.querySelector(".upload-image-preview").src = products[index].img;
    document.getElementById("ten-sach").value = products[index].title;
    document.getElementById("gia-moi").value = products[index].price;
    document.getElementById("mo-ta").value = products[index].desc;
    document.getElementById("chon-sach").value = products[index].category;
}

function getPathImage(path) {
    // If it's a data URL (from FileReader), don't process it
    if (path && path.startsWith('data:')) {
        return path;
    }
    // Kiểm tra nếu đường dẫn hợp lệ và chứa tên file
    if (path && path.includes('/') && !path.startsWith('data:')) {
        let patharr = path.split("/");
        return "./assets/img/products/" + patharr[patharr.length - 1];
    }
    return ""; // Trả về chuỗi rỗng nếu đường dẫn không hợp lệ
}

let btnUpdateProductIn = document.getElementById("update-product-button");
btnUpdateProductIn.addEventListener("click", async (e) => {
    e.preventDefault();

    let products = JSON.parse(localStorage.getItem("products"));
    if (!products || !Array.isArray(products)) {
        toast({ title: "Lỗi", message: "Danh sách sản phẩm không tìm thấy hoặc không hợp lệ!", type: "error", duration: 3000 });
        return;
    }

    // Get the file input element
    let fileInput = document.getElementById("up-hinh-anh");
    let file = fileInput.files[0];
    
    let titleProductCur = document.getElementById("ten-sach").value;
    let curProductCur = document.getElementById("gia-moi").value;
    let descProductCur = document.getElementById("mo-ta").value;
    let categoryText = document.getElementById("chon-sach").value;

    if (indexCur === undefined || indexCur < 0 || indexCur >= products.length) {
        toast({ title: "Lỗi", message: "Chỉ số sản phẩm không hợp lệ!", type: "error", duration: 3000 });
        return;
    }

    let idProduct = products[indexCur].id;
    let imgProduct = products[indexCur].img; // Old image path
    let titleProduct = products[indexCur].title;
    let curProduct = products[indexCur].price;
    let descProduct = products[indexCur].desc;
    let categoryProduct = products[indexCur].category;

    // Determine the new image path
    let newImgPath = imgProduct;
    if (file) {
        // A new file was selected - will be uploaded to server
        newImgPath = ""; // Will be set by server response
    } else if (document.querySelector(".upload-image-preview").src !== imgProduct && !document.querySelector(".upload-image-preview").src.startsWith('data:')) {
        // Image preview changed but no new file - it's a path change
        newImgPath = getPathImage(document.querySelector(".upload-image-preview").src) || imgProduct;
    }

    if (newImgPath !== imgProduct || titleProductCur !== titleProduct || curProductCur !== curProduct || descProductCur !== descProduct || categoryText !== categoryProduct) {
        try {
            let formData = new FormData();
            formData.append("id", idProduct);
            formData.append("title", titleProductCur);
            formData.append("category", categoryText);
            formData.append("price", parseInt(curProductCur));
            formData.append("desc", descProductCur);
            formData.append("status", 1);
            formData.append("oldImagePath", imgProduct);
            
            // Append the file if a new one was selected
            if (file) {
                formData.append("img", file);
            }

            // Gửi yêu cầu cập nhật sản phẩm đến máy chủ
            const response = await fetch("update-product.php", {
                method: "POST",
                body: formData
            });

            const result = await response.json();
            
            if (result.success) {
                // Update with server path
                let serverImgPath = result.img || imgProduct;
                
                let productadd = {
                    id: idProduct,
                    title: titleProductCur,
                    img: serverImgPath,
                    category: categoryText,
                    price: parseInt(curProductCur),
                    desc: descProductCur,
                    status: 1,
                };
                products.splice(indexCur, 1, productadd);
                localStorage.setItem("products", JSON.stringify(products));

                toast({ title: "Thành công", message: "Sửa sản phẩm thành công!", type: "success", duration: 3000 });
                setDefaultValue();
                // Reset file input
                fileInput.value = "";
                document.querySelector(".add-product").classList.remove("open");
                showProduct();
            } else {
                toast({ title: "Lỗi", message: result.message || "Có lỗi xảy ra khi cập nhật sản phẩm!", type: "error", duration: 3000 });
            }
        } catch (error) {
            toast({ title: "Lỗi", message: "Có lỗi xảy ra khi cập nhật sản phẩm!", type: "error", duration: 3000 });
        }
    } else {
        toast({ title: "Cảnh báo", message: "Sản phẩm của bạn không thay đổi!", type: "warning", duration: 3000 });
    }
});



let btnAddProductIn = document.getElementById("add-product-button");
btnAddProductIn.addEventListener("click", async (e) => {
    e.preventDefault();
    
    // Get the file input element
    let fileInput = document.getElementById("up-hinh-anh");
    let file = fileInput.files[0];
    
    let tensach = document.getElementById("ten-sach").value;
    let price = document.getElementById("gia-moi").value;
    let moTa = document.getElementById("mo-ta").value;
    let categoryText = document.getElementById("chon-sach").value;

    if (tensach == "" || price == "" || moTa == "") {
        toast({ title: "Chú ý", message: "Vui lòng nhập đầy đủ thông tin sách!", type: "warning", duration: 3000 });
    } else {
        if (isNaN(price)) {
            toast({ title: "Chú ý", message: "Giá phải ở dạng số!", type: "warning", duration: 3000 });
        } else {
            // Gửi dữ liệu sản phẩm mới đến server để thêm vào database
            try {
                let formData = new FormData();
                formData.append('title', tensach);
                // Append the actual file if selected
                if (file) {
                    formData.append('img', file);
                } else {
                    formData.append('img', '');
                }
                formData.append('category', categoryText);
                formData.append('price', parseInt(price));
                formData.append('desc', moTa);
                formData.append('status', 1);

                const response = await fetch('add_product.php', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();
                if (result.success) {
                    // Get the image path from server response
                    let serverImgPath = result.img || "./assets/img/blank-image.png";
                    
                    // Save to localStorage with the correct server path
                    let products = localStorage.getItem("products") ? JSON.parse(localStorage.getItem("products")) : [];
                    let product = {
                        id: createId(products),
                        title: tensach,
                        img: serverImgPath,
                        category: categoryText,
                        price: parseInt(price),
                        desc: moTa,
                        status: 1
                    };
                    products.unshift(product);
                    localStorage.setItem("products", JSON.stringify(products));
                    showProduct();
                    document.querySelector(".add-product").classList.remove("open");
                    setDefaultValue();
                    // Reset file input
                    fileInput.value = "";
                    
                    toast({ title: "Thành công", message: "Thêm sản phẩm thành công!", type: "success", duration: 3000 });
                } else {
                    toast({ title: "Lỗi", message: "Có lỗi xảy ra khi thêm sản phẩm vào cơ sở dữ liệu!", type: "error", duration: 3000 });
                }
            } catch (error) {
                console.error("Error adding product to database:", error);
                toast({ title: "Lỗi", message: "Không thể kết nối đến server!", type: "error", duration: 3000 });
            }
        }
    }
});


document.querySelector(".modal-close.product-form").addEventListener("click",() => {
    setDefaultValue();
})

function setDefaultValue() {
    document.querySelector(".upload-image-preview").src = "./assets/img/blank-image.png";
    document.getElementById("ten-sach").value = "";
    document.getElementById("gia-moi").value = "";
    document.getElementById("mo-ta").value = "";
    document.getElementById("chon-sach").value = "Sách khác";
}

// Open Popup Modal
let btnAddProduct = document.getElementById("btn-add-product");
btnAddProduct.addEventListener("click", () => {
    document.querySelectorAll(".add-product-e").forEach(item => {
        item.style.display = "block";
    })
    document.querySelectorAll(".edit-product-e").forEach(item => {
        item.style.display = "none";
    })
    document.querySelector(".add-product").classList.add("open");
});

// Close Popup Modal
let closePopup = document.querySelectorAll(".modal-close");
let modalPopup = document.querySelectorAll(".modal");

for (let i = 0; i < closePopup.length; i++) {
    closePopup[i].onclick = () => {
        modalPopup[i].classList.remove("open");
    };
}

// On change Image
function uploadImage(el) {
    const file = el.files[0];
    if (file) {
        // Use FileReader to preview the image
        const reader = new FileReader();
        reader.onload = function(e) {
            document.querySelector(".upload-image-preview").setAttribute("src", e.target.result);
        };
        reader.readAsDataURL(file);
    }
}

// Đổi trạng thái đơn hàng
function changeStatus(id, newStatus) {
    let orders = JSON.parse(localStorage.getItem("order"));
    let order = orders.find((item) => item.id == id);

    

    // Gửi yêu cầu AJAX tới PHP để cập nhật trạng thái đơn hàng trong database
    fetch('update_order_status.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ id: id, trangthai: parseInt(newStatus) })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Cập nhật trạng thái đơn hàng trong localStorage
    order.trangthai = parseInt(newStatus);
    // Removed old button code
    el.classList.add("btn-daxuly");
    el.innerHTML = "Đã xử lý";
    localStorage.setItem("order", JSON.stringify(orders));
    
    findOrder(orders);
            toast({ title: 'Success', message: 'Cập nhật trạng thái đơn hàng thành công!', type: 'success', duration: 3000 });
        } else {
            toast({ title: 'Thất bại', message: 'Đã xảy ra lỗi khi cập nhật trạng thái đơn hàng!', type: 'error', duration: 3000 });
        }
    })
    .catch(error => {
        //console.error('Error:', error);
        toast({ title: 'Thất bại', message: 'Đã xảy ra lỗi, vui lòng thử lại sau!', type: 'error', duration: 3000 });
    });
}


// Format Date
function formatDate(date) {
    let fm = new Date(date);
    let yyyy = fm.getFullYear();
    let mm = fm.getMonth() + 1;
    let dd = fm.getDate();
    if (dd < 10) dd = "0" + dd;
    if (mm < 10) mm = "0" + mm;
    return dd + "/" + mm + "/" + yyyy;
}

// Hàm lấy tên trạng thái
function getStatusName(trangthai) {
    switch(parseInt(trangthai)) {
        case 0: return 'Chờ xử lý';
        case 1: return 'Đang xử lý';
        case 2: return 'Đã xử lý';
        case 3: return 'Đã hủy';
        default: return 'Chờ xử lý';
    }
}

// Hàm lấy class CSS cho trạng thái
function getStatusClass(trangthai) {
    switch(parseInt(trangthai)) {
        case 0: return 'status-pending';    // Chờ xử lý - màu vàng
        case 1: return 'status-processing';  // Đang xử lý - màu xanh dương
        case 2: return 'status-complete';   // Đã xử lý - màu xanh lá
        case 3: return 'status-cancelled';  // Đã hủy - màu đỏ
        default: return 'status-pending';
    }
}

// Show order
function showOrder(arr) {
    let orderHtml = "";
    if(arr.length == 0) {
        orderHtml = `<td colspan="7">Không có dữ liệu</td>`
    } else {
        arr.forEach((item) => {
            let statusClass = getStatusClass(item.trangthai);
            let statusName = getStatusName(item.trangthai);
            let date = formatDate(item.thoigiandat);
            orderHtml += `
            <tr>
            <td>${item.id}</td>
            <td>${item.khachhang}</td>
            <td>${date}</td>
            <td>${vnd(item.tongtien)}</td>                               
            <td>
                <span class="${statusClass}">${statusName}</span>
            </td>
            <td class="control">
            <button class="btn-detail" onclick="detailOrder('${item.id}')"><i class="fa-regular fa-eye"></i> Chi tiết</button>
            <button class="btn-delete" onclick="deleteOrder('${item.id}')"><i class="fa-regular fa-trash"></i> Xóa</button>
            </td>
            </tr>      
            `;
        });
    }
    document.getElementById("showOrder").innerHTML = orderHtml;
}

// Delete order
function deleteOrder(orderId) {
    if(confirm("Bạn có chắc muốn xóa đơn hàng này? Hành động này không thể hoàn tác!") == true) {
        // Gọi API để xóa khỏi database trước
        fetch('delete_order.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id: orderId })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Chỉ xóa khỏi localStorage KHI API xóa thành công
                let orders = JSON.parse(localStorage.getItem("order"));
                let orderDetails = JSON.parse(localStorage.getItem("orderDetails"));
                
                // Remove order
                orders = orders.filter(order => order.id != orderId);
                
                // Remove order details
                if (orderDetails) {
                    orderDetails = orderDetails.filter(detail => detail.madon != orderId);
                }
                
                localStorage.setItem("order", JSON.stringify(orders));
                localStorage.setItem("orderDetails", JSON.stringify(orderDetails));
                
                // Show updated list
                showOrder(orders);
                
                toast({ title: 'Success', message: data.message || 'Xóa đơn hàng thành công!', type: 'success', duration: 3000 });
            } else {
                toast({ title: 'Thất bại', message: data.message || 'Đã xảy ra lỗi khi xóa đơn hàng!', type: 'error', duration: 3000 });
            }
        })
        .catch(error => {
            toast({ title: 'Thất bại', message: 'Đã xảy ra lỗi, vui lòng thử lại sau!', type: 'error', duration: 3000 });
        });
    }
}

// Hàm tải đơn hàng từ database mỗi khi truy cập
function loadOrdersFromDB() {
    console.log('=== DEBUG loadOrdersFromDB ===');
    
    // Load orders
    fetch('get_orders.php')
    .then(r => r.json())
    .then(orders => {
        console.log('Orders raw:', orders);
        localStorage.setItem('order', JSON.stringify(orders));
        
        // Load order details
        return fetch('get_order_details.php');
    })
    .then(r => r.json())
    .then(orderDetails => {
        console.log('OrderDetails raw:', orderDetails);
        localStorage.setItem('orderDetails', JSON.stringify(orderDetails));
        
        // Load products
        return fetch('get_products.php');
    })
    .then(r => r.json())
    .then(products => {
        console.log('Products loaded:', products.length);
        localStorage.setItem('products', JSON.stringify(products));
        
        let orders = JSON.parse(localStorage.getItem('order') || '[]');
        showOrder(orders);
    })
    .catch(err => {
        console.error('Lỗi tải đơn hàng:', err);
    });
}

window.onload = loadOrdersFromDB;

// Get Order Details
function getOrderDetails(madon) {
    let orderDetails = localStorage.getItem("orderDetails") ?
        JSON.parse(localStorage.getItem("orderDetails")) : [];
    let ctDon = [];
    orderDetails.forEach((item) => {
        if (item.madon == madon) {
            ctDon.push(item);
        }
    });
    return ctDon;
}

// Show Order Detail
function detailOrder(id) {
    document.querySelector(".modal.detail-order").classList.add("open");
    let orders = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];
    let products = localStorage.getItem("products") ? JSON.parse(localStorage.getItem("products")) : [];
    
    console.log('=== DEBUG detailOrder ===');
    console.log('Orders count:', orders.length);
    console.log('Products count:', products.length);
    console.log('Looking for order id:', id);
    
    // Lấy hóa đơn 
    let order = orders.find((item) => item.id == id);
    
    // Kiểm tra nếu không tìm thấy đơn hàng
    if (!order) {
        console.error('Không tìm thấy đơn hàng với id:', id);
        toast({ title: 'Lỗi', message: 'Không tìm thấy thông tin đơn hàng!', type: 'error', duration: 3000 });
        return;
    }
    
    // Lấy chi tiết hóa đơn
    let ctDon = getOrderDetails(id);
    let spHtml = `<div class="modal-detail-left"><div class="order-item-group">`;

    ctDon.forEach((item) => {
        // Tìm sản phẩm - so sánh cả string và number
        let detaiSP = products.find(product => String(product.id) === String(item.id) || product.id == item.id);
        
        // Sử dụng thông tin mặc định nếu sản phẩm không tồn tại
        let img = detaiSP ? detaiSP.img : './assets/img/blank-image.png';
        let title = detaiSP ? detaiSP.title : 'Sản phẩm #' + item.id;
        
        spHtml += `<div class="order-product">
            <div class="order-product-left">
                <img src="${img}" alt="">
                <div class="order-product-info">
                    <h4>${title}</h4>
                    <p class="order-product-note"><i class="fa-light fa-pen"></i> ${item.note || ''}</p>
                    <p class="order-product-quantity">SL: ${item.soluong || 0}<p>
                </div>
            </div>
            <div class="order-product-right">
                <div class="order-product-price">
                    <span class="order-product-current-price">${vnd(item.price || 0)}</span>
                </div>                         
            </div>
        </div>`;
    });
    spHtml += `</div></div>`;
    spHtml += `<div class="modal-detail-right">
        <ul class="detail-order-group">
            <li class="detail-order-item">
                <span class="detail-order-item-left"><i class="fa-light fa-calendar-days"></i> Ngày đặt hàng</span>
                <span class="detail-order-item-right">${formatDate(order.thoigiandat)}</span>
            </li>
            <li class="detail-order-item">
                <span class="detail-order-item-left"><i class="fa-light fa-truck"></i> Hình thức giao</span>
                <span class="detail-order-item-right">${order.hinhthucgiao}</span>
            </li>
            <li class="detail-order-item">
            <span class="detail-order-item-left"><i class="fa-thin fa-person"></i> Người nhận</span>
            <span class="detail-order-item-right">${order.tenguoinhan}</span>
            </li>
            <li class="detail-order-item">
            <span class="detail-order-item-left"><i class="fa-light fa-phone"></i> Số điện thoại</span>
            <span class="detail-order-item-right">${order.sdtnhan}</span>
            </li>
            <li class="detail-order-item tb">
                <span class="detail-order-item-left"><i class="fa-light fa-clock"></i> Thời gian giao</span>
                <p class="detail-order-item-b">${(order.thoigiangiao == "" ? "" : (order.thoigiangiao + " - ")) + formatDate(order.ngaygiaohang)}</p>
            </li>
            <li class="detail-order-item tb">
                <span class="detail-order-item-t"><i class="fa-light fa-location-dot"></i> Địa chỉ nhận</span>
                <p class="detail-order-item-b">${order.diachinhan}</p>
            </li>
            <li class="detail-order-item tb">
                <span class="detail-order-item-t"><i class="fa-light fa-note-sticky"></i> Ghi chú</span>
                <p class="detail-order-item-b">${order.ghichu}</p>
            </li>
            ${order.phiVanChuyen > 0 ? `
            <li class="detail-order-item">
                <span class="detail-order-item-left"><i class="fa-light fa-truck"></i> Phí vận chuyển</span>
                <span class="detail-order-item-right">${vnd(order.phiVanChuyen)}</span>
            </li>` : ''}
            ${order.giamGia > 0 ? `
            <li class="detail-order-item">
                <span class="detail-order-item-left"><i class="fa-light fa-tag"></i> Giảm giá</span>
                <span class="detail-order-item-right" style="color: #27ae60;">-${vnd(order.giamGia)}</span>
            </li>` : ''}
        </ul>
    </div>`;
    document.querySelector(".modal-detail-order").innerHTML = spHtml;
    
    // Hiển thị dropdown chọn trạng thái trong modal
    let currentStatus = parseInt(order.trangthai);
    
    // Add null check for modal-detail-bottom
    const modalDetailBottom = document.querySelector(".modal-detail-bottom");
    if (!modalDetailBottom) {
        console.error('modal-detail-bottom element not found');
        return;
    }
    
    modalDetailBottom.innerHTML = `<div class="modal-detail-bottom-left">
        <div class="price-total">
            <span class="thanhtien">Thành tiền</span>
            <span class="price">${vnd(order.tongtien)}</span>
        </div>
    </div>
    <div class="modal-detail-bottom-right">
        <select class="status-select-modal" onchange="changeStatus('${order.id}', this.value)">
            <option value="0" ${currentStatus == 0 ? 'selected' : ''}>Chờ xử lý</option>
            <option value="1" ${currentStatus == 1 ? 'selected' : ''}>Đang xử lý</option>
            <option value="2" ${currentStatus == 2 ? 'selected' : ''}>Đã xử lý</option>
            <option value="3" ${currentStatus == 3 ? 'selected' : ''}>Đã hủy</option>
        </select>
    </div>`;
}

// Find Order
function findOrder() {
    let tinhTrang = parseInt(document.getElementById("tinh-trang").value);
    let ct = document.getElementById("form-search-order").value;
    let timeStart = document.getElementById("time-start").value;
    let timeEnd = document.getElementById("time-end").value;
    
    if (timeEnd < timeStart && timeEnd != "" && timeStart != "") {
        alert("Lựa chọn thời gian sai !");
        return;
    }
    let orders = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];
    let result = tinhTrang == 2 ? orders : orders.filter((item) => {
        return item.trangthai == tinhTrang;
    });
    result = ct == "" ? result : result.filter((item) => {
        return (item.khachhang.toLowerCase().includes(ct.toLowerCase()) || item.id.toString().toLowerCase().includes(ct.toLowerCase()));
    });

    if (timeStart != "" && timeEnd == "") {
        result = result.filter((item) => {
            return new Date(item.thoigiandat) >= new Date(timeStart).setHours(0, 0, 0);
        });
    } else if (timeStart == "" && timeEnd != "") {
        result = result.filter((item) => {
            return new Date(item.thoigiandat) <= new Date(timeEnd).setHours(23, 59, 59);
        });
    } else if (timeStart != "" && timeEnd != "") {
        result = result.filter((item) => {
            return (new Date(item.thoigiandat) >= new Date(timeStart).setHours(0, 0, 0) && new Date(item.thoigiandat) <= new Date(timeEnd).setHours(23, 59, 59)
            );
        });
    }
    showOrder(result);
}

function cancelSearchOrder(){
    let orders = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];
    document.getElementById("tinh-trang").value = 2;
    document.getElementById("form-search-order").value = "";
    document.getElementById("time-start").value = "";
    document.getElementById("time-end").value = "";
    showOrder(orders);
}

// Create Object Thong ke
function createObj() {
    let orders = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];
    let products = localStorage.getItem("products") ? JSON.parse(localStorage.getItem("products")) : []; 
    let orderDetails = localStorage.getItem("orderDetails") ? JSON.parse(localStorage.getItem("orderDetails")) : []; 
    let result = [];
    orderDetails.forEach(item => {
        // Lấy thông tin sản phẩm
        let prod = products.find(product => {return product.id == item.id;});
        // Kiểm tra nếu sản phẩm không tồn tại
        if (!prod) {
            return; // Bỏ qua nếu sản phẩm không tồn tại
        }
        let obj = new Object();
        obj.id = item.id;
        obj.madon = item.madon;
        obj.price = item.price;
        obj.quantity = item.soluong;
        obj.category = prod.category || '';
        obj.title = prod.title || '';
        obj.img = prod.img || '';
        let order = orders.find(order => order.id == item.madon);
        obj.time = order ? order.thoigiandat : '';
        result.push(obj);
    });
    return result;
}

// Filter 
function thongKe(mode) {
    let categoryTk = document.getElementById("the-loai-tk").value;
    let ct = document.getElementById("form-search-tk").value;
    let timeStart = document.getElementById("time-start-tk").value;
    let timeEnd = document.getElementById("time-end-tk").value;
    if (timeEnd < timeStart && timeEnd != "" && timeStart != "") {
        alert("Lựa chọn thời gian sai !");
        return;
    }
    let arrDetail = createObj();
    let result = categoryTk == "Tất cả" ? arrDetail : arrDetail.filter((item) => {
        return item.category == categoryTk;
    });

    result = ct == "" ? result : result.filter((item) => {
        return (item.title.toLowerCase().includes(ct.toLowerCase()));
    });

    if (timeStart != "" && timeEnd == "") {
        result = result.filter((item) => {
            return new Date(item.time) > new Date(timeStart).setHours(0, 0, 0);
        });
    } else if (timeStart == "" && timeEnd != "") {
        result = result.filter((item) => {
            return new Date(item.time) < new Date(timeEnd).setHours(23, 59, 59);
        });
    } else if (timeStart != "" && timeEnd != "") {
        result = result.filter((item) => {
            return (new Date(item.time) > new Date(timeStart).setHours(0, 0, 0) && new Date(item.time) < new Date(timeEnd).setHours(23, 59, 59)
            );
        });
    }    
    showThongKe(result,mode);
}

// Show số lượng sp, số lượng đơn bán, doanh thu
function showOverview(arr){
    document.getElementById("quantity-product").innerText = arr.length;
    document.getElementById("quantity-order").innerText = arr.reduce((sum, cur) => (sum + parseInt(cur.quantity)),0);
    document.getElementById("quantity-sale").innerText = vnd(arr.reduce((sum, cur) => (sum + parseInt(cur.doanhthu)),0));
}

function showThongKe(arr,mode) {
    let orderHtml = "";
    let mergeObj = mergeObjThongKe(arr);
    showOverview(mergeObj);

    switch (mode){
        case 0:
            mergeObj = mergeObjThongKe(createObj());
            showOverview(mergeObj);
            document.getElementById("the-loai-tk").value = "Tất cả";
            document.getElementById("form-search-tk").value = "";
            document.getElementById("time-start-tk").value = "";
            document.getElementById("time-end-tk").value = "";
            break;
        case 1:
            mergeObj.sort((a,b) => parseInt(a.quantity) - parseInt(b.quantity))
            break;
        case 2:
            mergeObj.sort((a,b) => parseInt(b.quantity) - parseInt(a.quantity))
            break;
    }
    for(let i = 0; i < mergeObj.length; i++) {
        orderHtml += `
        <tr>
        <td>${i + 1}</td>
        <td><div class="prod-img-title"><img class="prd-img-tbl" src="${mergeObj[i].img}" alt=""><p>${mergeObj[i].title}</p></div></td>
        <td>${mergeObj[i].quantity}</td>
        <td>${vnd(mergeObj[i].doanhthu)}</td>
        <td><button class="btn-detail product-order-detail" data-id="${mergeObj[i].id}"><i class="fa-regular fa-eye"></i> Chi tiết</button></td>
        </tr>      
        `;
    }
    document.getElementById("showTk").innerHTML = orderHtml;
    document.querySelectorAll(".product-order-detail").forEach(item => {
        let idProduct = item.getAttribute("data-id");
        item.addEventListener("click", () => {           
            detailOrderProduct(arr,idProduct);
        })
    })
}

showThongKe(createObj())

function mergeObjThongKe(arr) {
    let result = [];
    arr.forEach(item => {
        let check = result.find(i => i.id == item.id) // Không tìm thấy gì trả về undefined

        if(check){
            check.quantity = parseInt(check.quantity)  + parseInt(item.quantity);
            check.doanhthu += parseInt(item.price) * parseInt(item.quantity);
        } else {
            const newItem = {...item}
            newItem.doanhthu = newItem.price * newItem.quantity;
            result.push(newItem);
        }
        
    });
    return result;
}

function detailOrderProduct(arr,id) {
    let orderHtml = "";
    arr.forEach(item => {
        if(item.id == id) {
            orderHtml += `<tr>
            <td>${item.madon}</td>
            <td>${item.quantity}</td>
            <td>${vnd(item.price || 0)}</td>
            <td>${formatDate(item.time)}</td>
            </tr>      
            `;
        }
    });
    document.getElementById("show-product-order-detail").innerHTML = orderHtml
    document.querySelector(".modal.detail-order-product").classList.add("open")
}

// User
let addAccount = document.getElementById('signup-button');
let updateAccount = document.getElementById("btn-update-account")

// THÊM MỚI: Event listener cho nút cập nhật tài khoản
if (updateAccount) {
    updateAccount.addEventListener("click", updateAccountFunc);
}

document.querySelector(".modal.signup .modal-close").addEventListener("click",() => {
    signUpFormReset();
})

function openCreateAccount() {
    document.querySelector(".signup").classList.add("open");
    document.querySelectorAll(".edit-account-e").forEach(item => {
        item.style.display = "none"
    })
    document.querySelectorAll(".add-account-e").forEach(item => {
        item.style.display = "block"
    })
}

function signUpFormReset() {
    document.getElementById('fullname').value = ""
    document.getElementById('phone').value = ""
    document.getElementById('password').value = ""
    document.querySelector('.form-message-name').innerHTML = '';
    document.querySelector('.form-message-phone').innerHTML = '';
    document.querySelector('.form-message-password').innerHTML = '';
}

function showUserArr(arr) {
    let accountHtml = '';
    if(arr.length == 0) {
        accountHtml = `<td colspan="7">Không có dữ liệu</td>`
    } else {
        arr.forEach((account, index) => {
            let tinhtrang = account.status == 0 ? `<span class="status-no-complete">Bị khóa</span>` : `<span class="status-complete">Hoạt động</span>`;
            // Hiển thị vai trò: userType = 1 là Quản trị, userType = 0 là Người dùng
            let vaitro = account.userType == 1 ? `<span class="status-admin">Quản trị</span>` : `<span class="status-user">Người dùng</span>`;
            accountHtml += ` <tr>
            <td>${index + 1}</td>
            <td>${account.fullname}</td>
            <td>${account.phone}</td>
            <td>${formatDate(account.join)}</td>
            <td>${tinhtrang}</td>
            <td>${vaitro}</td>
            <td class="control control-table">
            <button class="btn-edit" id="edit-account" onclick='editAccount("${account.phone}")' ><i class="fa-light fa-pen-to-square"></i></button>
            <button class="btn-delete" id="delete-account" onclick="deleteAccount('${account.phone}')"><i class="fa-regular fa-trash"></i></button>
            </td>
        </tr>`
        })
    }
    document.getElementById('show-user').innerHTML = accountHtml;
}

function showUser() {
    let tinhTrang = parseInt(document.getElementById("tinh-trang-user").value);
    let ct = document.getElementById("form-search-user").value;
    let timeStart = document.getElementById("time-start-user").value;
    let timeEnd = document.getElementById("time-end-user").value;

    if (timeEnd < timeStart && timeEnd != "" && timeStart != "") {
        alert("Lựa chọn thời gian sai !");
        return;
    }

    // Hiển thị TẤT CẢ người dùng (bao gồm cả admin và user)
    let accounts = localStorage.getItem("accounts") ? JSON.parse(localStorage.getItem("accounts")) : [];
    let result = tinhTrang == 2 ? accounts : accounts.filter(item => item.status == tinhTrang);

    result = ct == "" ? result : result.filter((item) => {
        return (item.fullname.toLowerCase().includes(ct.toLowerCase()) || item.phone.toString().toLowerCase().includes(ct.toLowerCase()));
    });

    if (timeStart != "" && timeEnd == "") {
        result = result.filter((item) => {
            return new Date(item.join) >= new Date(timeStart).setHours(0, 0, 0);
        });
    } else if (timeStart == "" && timeEnd != "") {
        result = result.filter((item) => {
            return new Date(item.join) <= new Date(timeEnd).setHours(23, 59, 59);
        });
    } else if (timeStart != "" && timeEnd != "") {
        result = result.filter((item) => {
            return (new Date(item.join) >= new Date(timeStart).setHours(0, 0, 0) && new Date(item.join) <= new Date(timeEnd).setHours(23, 59, 59)
            );
        });
    }
    showUserArr(result);
}

function cancelSearchUser() {
    let accounts = localStorage.getItem("accounts") ? JSON.parse(localStorage.getItem("accounts")).filter(item => item.userType == 0) : [];
    showUserArr(accounts);
    document.getElementById("tinh-trang-user").value = 2;
    document.getElementById("form-search-user").value = "";
    document.getElementById("time-start-user").value = "";
    document.getElementById("time-end-user").value = "";
}

// Hàm tải dữ liệu users từ database mỗi khi truy cập
function loadUsersFromDB() {
    fetch('getAccounts.php')
        .then(response => response.json())
        .then(data => {
            // Ép kiểu phone sang string để tránh vấn đề octal
            const accounts = data.map(account => ({
                fullname: account.fullname,
                phone: String(account.phone),
                password: account.password,
                address: account.address,
                email: account.email,
                status: account.status,
                join: new Date(account.join_date),
                cart: account.cart || [],
                userType: account.userType
            }));
            
            // Lưu vào localStorage
            localStorage.setItem('accounts', JSON.stringify(accounts));
            showUser();
        });
}

window.onload = function() {
    // Luôn tải dữ liệu mới từ database khi truy cập
    loadUsersFromDB();
};

function deleteAccount(phone) {
    // Ép phone sang string để tránh vấn đề parse (ví dụ: "095421" thành 0)
    let phoneStr = String(phone);
    let accounts = JSON.parse(localStorage.getItem('accounts'));
    let index = accounts.findIndex(item => String(item.phone) === phoneStr);
    
    // Debug: log để tìm vấn đề
    console.log('deleteAccount called with phone:', phone, '| index found:', index);
    console.log('accounts sample:', accounts.slice(0, 3));

    if (index === -1) {
        console.error('Cannot find account with phone:', phone);
        toast({ title: 'Lỗi', message: 'Không tìm thấy tài khoản!', type: 'error', duration: 3000 });
        return;
    }

    if (confirm("Bạn có chắc muốn xóa?")) {
        // Gửi yêu cầu AJAX tới PHP để xóa tài khoản trong database
        fetch('delete_account.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ phone: String(phone) })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Chỉ xóa khỏi localStorage KHI PHP xóa thành công
                accounts.splice(index, 1);
                localStorage.setItem("accounts", JSON.stringify(accounts));
                showUser();
                toast({ title: 'Success', message: data.message || 'Xóa tài khoản thành công!', type: 'success', duration: 3000 });
            } else {
                toast({ title: 'Thất bại', message: data.message || 'Đã xảy ra lỗi khi xóa tài khoản!', type: 'error', duration: 3000 });
            }
        })
        .catch(error => {
            //console.error('Error:', error);
            toast({ title: 'Thất bại', message: 'Đã xảy ra lỗi, vui lòng thử lại sau!', type: 'error', duration: 3000 });
        });
    }
}


let indexFlag;
function editAccount(phone) {
    // Debug: log giá trị phone
    console.log('editAccount called with phone:', phone, 'type:', typeof phone);
    
    document.querySelector(".signup").classList.add("open");
    document.querySelectorAll(".add-account-e").forEach(item => {
        item.style.display = "none"
    })
    document.querySelectorAll(".edit-account-e").forEach(item => {
        item.style.display = "block"
    })
    let accounts = JSON.parse(localStorage.getItem("accounts"));
    
    console.log('Accounts sample:', accounts.slice(0, 2));
    
    // Tìm account - so sánh cả string và number
    let index = accounts.findIndex(item => {
        return String(item.phone) === String(phone) || item.phone == phone;
    });
    
    console.log('Found index:', index);
    console.log('Account data:', accounts[index]);
    
    if (index === -1) {
        toast({ title: 'Lỗi', message: 'Không tìm thấy tài khoản!', type: 'error', duration: 3000 });
        return;
    }
    
    // Lưu phone để cập nhật (không dùng indexFlag vì có thể bị hoisting issue)
    let account = accounts[index];
    window.selectedAccountPhone = account.phone;
    
    console.log('Setting values:', {
        fullname: account.fullname,
        phone: account.phone,
        password: account.password,
        status: account.status
    });
    
    document.getElementById("fullname").value = account.fullname || '';
    document.getElementById("phone").value = String(account.phone) || '';
    document.getElementById("password").value = account.password || '';
    // Sửa logic status: status = 1 hoặc "1" hoặc true = checked
    const isActive = account.status == 1 || account.status === "1" || account.status === true;
    document.getElementById("user-status").checked = isActive;
    
    console.log('Fields set successfully');
}

// Hàm cập nhật thông tin tài khoản
function updateAccountFunc(e) {
    if (e) e.preventDefault();
    let accounts = JSON.parse(localStorage.getItem("accounts"));
    let fullname = document.getElementById("fullname").value;
    let phone = document.getElementById("phone").value;
    let password = document.getElementById("password").value;
    let status = document.getElementById("user-status").checked;
    
    // Validate
    if(fullname == "" || phone == "" || password == "") {
        toast({ title: 'Chú ý', message: 'Vui lòng nhập đầy đủ thông tin!', type: 'warning', duration: 3000 });
        return;
    }
    
    // Tìm và cập nhật trong localStorage bằng phone
    let index = accounts.findIndex(item => String(item.phone) === String(window.selectedAccountPhone));
    if (index !== -1) {
        accounts[index].fullname = fullname;
        accounts[index].phone = phone;
        accounts[index].password = password;
        accounts[index].status = status;
        localStorage.setItem("accounts", JSON.stringify(accounts));
    }
        
        // Gửi yêu cầu AJAX tới PHP để cập nhật database
        fetch('update_account.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                fullname: fullname,
                phone: phone,
                password: password,
                status: status
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                toast({ title: 'Thành công', message: 'Thay đổi thông tin thành công!', type: 'success', duration: 3000 });
                document.querySelector(".signup").classList.remove("open");
                signUpFormReset();
                showUser();
            } else {
                toast({ title: 'Thất bại', message: 'Đã xảy ra lỗi khi cập nhật tài khoản!', type: 'error', duration: 3000 });
            }
        })
        .catch(error => {
            toast({ title: 'Thất bại', message: 'Đã xảy ra lỗi, vui lòng thử lại sau!', type: 'error', duration: 3000 });
        });
}

// Hàm thêm tài khoản mới
addAccount.addEventListener("click", (e) => {
    e.preventDefault();
    let fullNameUser = document.getElementById('fullname').value;
    let phoneUser = document.getElementById('phone').value;
    let passwordUser = document.getElementById('password').value;

    // Check validate (giữ nguyên mã kiểm tra hiện tại)
    
    if (fullNameUser && phoneUser && passwordUser) {
        let user = {
            fullname: fullNameUser,
            phone: phoneUser,
            password: passwordUser,
            address: '',
            email: '',
            status: 1,
            join: new Date(),
            cart: [],
            userType: 0
        }
        
        let accounts = localStorage.getItem('accounts') ? JSON.parse(localStorage.getItem('accounts')) : [];
        let checkloop = accounts.some(account => account.phone == user.phone);

        if (!checkloop) {
            accounts.push(user);
            localStorage.setItem('accounts', JSON.stringify(accounts));

            // Gửi yêu cầu AJAX tới PHP để thêm tài khoản vào database
            fetch('add_account.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(user)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toast({ title: 'Thành công', message: 'Tạo thành công tài khoản!', type: 'success', duration: 3000 });
                    document.querySelector(".signup").classList.remove("open");
                    showUser();
                    signUpFormReset();
                } else {
                    toast({ title: 'Thất bại', message: 'Đã xảy ra lỗi khi thêm tài khoản!', type: 'error', duration: 3000 });
                }
            })
            .catch(error => {
                //console.error('Error:', error);
                toast({ title: 'Thất bại', message: 'Đã xảy ra lỗi, vui lòng thử lại sau!', type: 'error', duration: 3000 });
            });
        } else {
            toast({ title: 'Cảnh báo!', message: 'Tài khoản đã tồn tại!', type: 'error', duration: 3000 });
        }
    }
});


document.getElementById("logout-acc").addEventListener('click', (e) => {
    e.preventDefault();
    localStorage.removeItem("currentuser");
    window.location.href = "./index.php";
})

// ===== QUẢN LÝ ĐÁNH GIÁ =====

// Load ratings for admin
function loadRatings() {
    fetch('api/rating.php?admin=all')
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                displayRatings(data.ratings);
            }
        })
        .catch(error => console.error('Error loading ratings:', error));
}

// Display ratings in table
function displayRatings(ratings) {
    let html = '';
    ratings.forEach((rating, index) => {
        const date = new Date(rating.created_at).toLocaleDateString('vi-VN');
        const stars = '★'.repeat(rating.rating) + '☆'.repeat(5 - rating.rating);
        const productTitle = rating.product_title || 'Sản phẩm #' + rating.product_id;
        const userName = rating.fullname || rating.email || 'Ẩn danh';
        
        html += `
            <tr>
                <td>${index + 1}</td>
                <td>${productTitle}</td>
                <td>${userName}</td>
                <td style="color:#f39c12;">${stars}</td>
                <td>${rating.comment || '-'}</td>
                <td>${date}</td>
                <td>
                    <button onclick="deleteRating(${rating.id})" style="background:#e74c3c;color:#fff;padding:5px 10px;border:none;border-radius:4px;cursor:pointer;">
                        <i class="fa-solid fa-trash"></i> Xóa
                    </button>
                </td>
            </tr>
        `;
    });
    document.getElementById('showRatings').innerHTML = html;
}

// Delete a rating
function deleteRating(ratingId) {
    if (!confirm('Bạn có chắc muốn xóa đánh giá này?')) return;
    
    fetch('api/rating.php', {
        method: 'DELETE',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({id: ratingId})
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            toast({title: 'Success', message: data.message, type: 'success', duration: 3000});
            loadRatings();
        } else {
            toast({title: 'Error', message: data.message, type: 'error', duration: 3000});
        }
    })
    .catch(error => {
        toast({title: 'Error', message: 'Lỗi khi xóa', type: 'error', duration: 3000});
    });
}






