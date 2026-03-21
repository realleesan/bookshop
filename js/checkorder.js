// Sự kiện tra cứu đơn hàng
document.querySelector(".form-tracuu").addEventListener("submit", (e) => {
    e.preventDefault(); // Ngăn chặn hành vi mặc định của form

    // Lấy số điện thoại từ input
    let sdt = document.querySelector(".tracuudon").value;

    // Kiểm tra nếu số điện thoại không trống
    if (sdt === "") {
        toast({ title: "Chú ý", message: "Vui lòng nhập số điện thoại!", type: "warning", duration: 3000 });
        return;
    }

    // Lấy danh sách đơn hàng từ localStorage
    let orders = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];

    // Lọc danh sách đơn hàng theo số điện thoại
    let filteredOrders = orders.filter(order => order.sdtnhan === sdt);

    // Hiển thị kết quả tra cứu
    showOrdersdt(filteredOrders);
});

// Hàm hiển thị đơn hàng
function showOrdersdt(arr) {
    let orderHtml = ``;
    if (arr.length === 0) {
        orderHtml = `<br><h2>Giỏ hàng của bạn vẫn đang chờ bạn!<br>Đừng bỏ lỡ những sản phẩm tuyệt vời từ Shop mình nhé (^.^)</h2>`;
    } else {
        orderHtml = '<br><div class="main-account"><div class="main-account-header"><h3>Thông tin đơn hàng từ SĐT của bạn</h3><p>Xem chi tiết, trạng thái của những đơn hàng.</p></div><div class="section"><div class="table"><table width="100%"><thead><tr><td>Mã đơn</td><td>Tên người nhận</td><td>Ngày đặt</td><td>Tổng tiền</td><td>Trạng thái</td><td>Thao tác</td></tr></thead><tbody>';
        arr.forEach((item) => {
            let status = item.trangthai === 0 ? `<span class="status-no-complete">Chưa xử lý</span>` : `<span class="status-complete">Đã xử lý</span>`;
            let date = formatDate(item.thoigiandat);
            orderHtml += `
            <tr>
                <td>${item.id}</td>
                <td>${item.tenguoinhan}</td>
                <td>${date}</td>
                <td>${vnd(item.tongtien)}</td>
                <td>${status}</td>
                <td class="control">
                    <button class="btn-detail" onclick="detailOrder('${item.id}')"><i class="fa-regular fa-eye"></i> Chi tiết</button>
                </td>
            </tr>`;
        });
        orderHtml += '</tbody></table></div></div></div>';
    }
    document.getElementById("showOrdersdt").innerHTML = orderHtml;
}

// Hàm định dạng tiền tệ (vnd)
function vnd(price) {
    return price.toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
}

// Hàm định dạng ngày tháng
function formatDate(dateString) {
    let date = new Date(dateString);
    return date.toLocaleDateString('vi-VN');
}

// Hàm hiển thị chi tiết đơn hàng
// function detailOrder(id) {
//     let orders = localStorage.getItem("order") ? JSON.parse(localStorage.getItem("order")) : [];
//     let products = localStorage.getItem("products") ? JSON.parse(localStorage.getItem("products")) : [];
//     let order = orders.find((item) => item.id == id);
//     let ctDon = getOrderDetails(id);

//     let spHtml = `<div class="modal-detail-left"><div class="order-item-group">`;

//     ctDon.forEach((item) => {
//         let detaiSP = products.find(product => product.id == item.id);
//         spHtml += `<div class="order-product">
//             <div class="order-product-left">
//                 <img src="${detaiSP.img}" alt="">
//                 <div class="order-product-info">
//                     <h4>${detaiSP.title}</h4>
//                     <p class="order-product-note"><i class="fa-light fa-pen"></i> ${item.note}</p>
//                     <p class="order-product-quantity">SL: ${item.soluong}<p>
//                 </div>
//             </div>
//             <div class="order-product-right">
//                 <div class="order-product-price">
//                     <span class="order-product-current-price">${vnd(item.price)}</span>
//                 </div>                         
//             </div>
//         </div>`;
//     });
//     spHtml += `</div></div>`;
//     spHtml += `<div class="modal-detail-right">
//         <ul class="detail-order-group">
//             <li class="detail-order-item">
//                 <span class="detail-order-item-left"><i class="fa-light fa-calendar-days"></i> Ngày đặt hàng</span>
//                 <span class="detail-order-item-right">${formatDate(order.thoigiandat)}</span>
//             </li>
//             <li class="detail-order-item">
//                 <span class="detail-order-item-left"><i class="fa-light fa-truck"></i> Hình thức giao</span>
//                 <span class="detail-order-item-right">${order.hinhthucgiao}</span>
//             </li>
//             <li class="detail-order-item">
//             <span class="detail-order-item-left"><i class="fa-thin fa-person"></i> Người nhận</span>
//             <span class="detail-order-item-right">${order.tenguoinhan}</span>
//             </li>
//             <li class="detail-order-item">
//             <span class="detail-order-item-left"><i class="fa-light fa-phone"></i> Số điện thoại</span>
//             <span class="detail-order-item-right">${order.sdtnhan}</span>
//             </li>
//             <li class="detail-order-item tb">
//                 <span class="detail-order-item-left"><i class="fa-light fa-clock"></i> Thời gian giao</span>
//                 <p class="detail-order-item-b">${(order.thoigiangiao == "" ? "" : (order.thoigiangiao + " - ")) + formatDate(order.ngaygiaohang)}</p>
//             </li>
//             <li class="detail-order-item tb">
//                 <span class="detail-order-item-t"><i class="fa-light fa-location-dot"></i> Địa chỉ nhận</span>
//                 <p class="detail-order-item-b">${order.diachinhan}</p>
//             </li>
//             <li class="detail-order-item tb">
//                 <span class="detail-order-item-t"><i class="fa-light fa-note-sticky"></i> Ghi chú</span>
//                 <p class="detail-order-item-b">${order.ghichu}</p>
//             </li>
//         </ul>
//     </div>`;
//     document.querySelector(".modal-detail-order").innerHTML = spHtml;

//     let classDetailBtn = order.trangthai == 0 ? "btn-chuaxuly" : "btn-daxuly";
//     let textDetailBtn = order.trangthai == 0 ? "Chưa xử lý" : "Đã xử lý";
//     document.querySelector(
//         ".modal-detail-bottom"
//     ).innerHTML = `<div class="modal-detail-bottom-left">
//         <div class="price-total">
//             <span class="thanhtien">Thành tiền</span>
//             <span class="price">${vnd(order.tongtien)}</span>
//         </div>
//     </div>
//     <div class="modal-detail-bottom-right">
//         <button class="modal-detail-btn ${classDetailBtn}" onclick="changeStatus('${order.id}',this)">${textDetailBtn}</button>
//     </div>`;
// }

// Hàm lấy chi tiết đơn hàng từ localStorage
function getOrderDetails(madon) {
    let orderDetails = localStorage.getItem("orderDetails") ?
        JSON.parse(localStorage.getItem("orderDetails")) : [];
    let ctDon = orderDetails.filter(item => item.madon == madon);
    return ctDon;
}
