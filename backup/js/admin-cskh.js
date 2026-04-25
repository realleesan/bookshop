// CSKH Chat Functions for Admin
let selectedUserId = null;
let selectedUserName = null;
let cskhInterval = null;

// Initialize CSKH when tab is clicked
function initCSKH() {
    loadConversations();
    startCSKHPolling();
}

// Load all conversations
async function loadConversations() {
    try {
        const response = await fetch('api/chat_get_conversations.php');
        const conversations = await response.json();
        
        const container = document.getElementById('cskh-conversations');
        
        if (!conversations || conversations.length === 0) {
            container.innerHTML = '<div class="cskh-empty">Chưa có cuộc trò chuyện nào</div>';
            return;
        }
        
        container.innerHTML = conversations.map(conv => {
            // Priority: fullname > phone > user_id
            let userName = conv.fullname;
            if (!userName || userName.trim() === '') {
                userName = conv.phone;
            }
            if (!userName || userName.trim() === '') {
                userName = 'Khách hàng';
            }
            
            const lastMessage = conv.last_message || 'Chưa có tin nhắn';
            const lastTime = conv.last_message_at ? new Date(conv.last_message_at).toLocaleString('vi-VN', {
                day: '2-digit',
                month: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            }) : '';
            
            return `
                <div class="cskh-user-item" onclick="selectConversation(${conv.user_id}, '${escapeHtml(userName)}')">
                    <div class="cskh-user-name">
                        ${escapeHtml(userName)}
                        ${conv.unread_count > 0 ? `<span class="cskh-unread-badge">${conv.unread_count}</span>` : ''}
                    </div>
                    <div class="cskh-user-preview">${escapeHtml(lastMessage)}</div>
                    <div class="cskh-user-time">${lastTime}</div>
                </div>
            `;
        }).join('');
        
        // Update sidebar notification
        updateCSKHNotification();
    } catch (error) {
        console.error('Error loading conversations:', error);
    }
}

// Select a conversation
async function selectConversation(userId, userName) {
    selectedUserId = userId;
    selectedUserName = userName;
    
    // Update active state in list
    document.querySelectorAll('.cskh-user-item').forEach(item => {
        item.classList.remove('active');
    });
    event.target.closest('.cskh-user-item').classList.add('active');
    
    // Update header with delete button
    document.getElementById('cskh-chat-header').innerHTML = `
        <span>Chat với: ${userName}</span>
        <button class="cskh-delete-btn" onclick="deleteConversation()">
            <i class="fa-light fa-trash"></i> Xóa
        </button>
    `;
    
    // Load messages
    await loadMessages(userId);
}

// Load messages for selected conversation
async function loadMessages(userId) {
    try {
        const response = await fetch(`api/chat_get_messages.php?user_id=${userId}`);
        const messages = await response.json();
        
        const container = document.getElementById('cskh-messages');
        
        if (!messages || messages.length === 0) {
            container.innerHTML = '<div class="cskh-empty">Chưa có tin nhắn nào</div>';
            return;
        }
        
        container.innerHTML = messages.map(msg => {
            const time = new Date(msg.created_at).toLocaleTimeString('vi-VN', {
                hour: '2-digit',
                minute: '2-digit'
            });
            
            return `
                <div class="cskh-message ${msg.sender_type}">
                    <div class="cskh-message-bubble">
                        ${escapeHtml(msg.message)}
                        <div class="cskh-message-time">${time}</div>
                    </div>
                </div>
            `;
        }).join('');
        
        // Scroll to bottom
        container.scrollTop = container.scrollHeight;
    } catch (error) {
        console.error('Error loading messages:', error);
    }
}

// Delete conversation
async function deleteConversation() {
    if (!selectedUserId) return;
    
    if (!confirm('Bạn có chắc muốn xóa cuộc trò chuyện này?')) {
        return;
    }
    
    try {
        const response = await fetch('api/chat_delete_conversation.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                user_id: selectedUserId
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            selectedUserId = null;
            selectedUserName = null;
            
            // Reset chat area
            document.getElementById('cskh-chat-header').innerHTML = '<span>Chọn một cuộc trò chuyện</span>';
            document.getElementById('cskh-messages').innerHTML = '<div class="cskh-empty">Vui lòng chọn cuộc trò chuyện từ danh sách bên trái</div>';
            
            // Reload conversations
            loadConversations();
        } else {
            alert('Không thể xóa cuộc trò chuyện: ' + result.error);
        }
    } catch (error) {
        console.error('Error deleting conversation:', error);
        alert('Lỗi kết nối');
    }
}

// Handle Enter key in CSKH input
function handleCSKHKeyDown(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
        event.preventDefault();
        sendCSKHMessage();
    }
}

// Send message as admin
async function sendCSKHMessage() {
    const input = document.getElementById('cskh-input');
    const sendBtn = document.getElementById('cskh-send-btn');
    const message = input.value.trim();
    
    if (!selectedUserId) {
        alert('Vui lòng chọn cuộc trò chuyện');
        return;
    }
    
    if (!message) return;
    
    sendBtn.disabled = true;
    
    try {
        const response = await fetch('api/chat_send.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                user_id: selectedUserId,
                message: message,
                sender_type: 'admin'
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            input.value = '';
            loadMessages(selectedUserId);
            loadConversations(); // Refresh to update last message
        } else {
            alert('Không thể gửi tin nhắn: ' + result.error);
        }
    } catch (error) {
        console.error('Error sending message:', error);
        alert('Lỗi kết nối');
    } finally {
        sendBtn.disabled = false;
    }
}

// Start polling for new messages
function startCSKHPolling() {
    if (cskhInterval) clearInterval(cskhInterval);
    
    cskhInterval = setInterval(() => {
        // Only refresh if CSKH section is visible
        const cskhSection = document.getElementById('cskh-section');
        if (cskhSection && !cskhSection.classList.contains('hidden')) {
            loadConversations();
            if (selectedUserId) {
                loadMessages(selectedUserId);
            }
        }
    }, 5000);
}

// Update CSKH notification badge
async function updateCSKHNotification() {
    try {
        const response = await fetch('api/chat_get_unread_count.php');
        const data = await response.json();
        
        const cskhItem = document.querySelector('[data-tab="cskh"]');
        if (cskhItem) {
            let badge = cskhItem.querySelector('.cskh-badge');
            if (!badge) {
                badge = document.createElement('span');
                badge.className = 'cskh-badge';
                badge.style.cssText = 'background: #dc3545; color: white; font-size: 11px; padding: 2px 6px; border-radius: 10px; margin-left: 5px;';
                cskhItem.querySelector('.sidebar-link').insertAdjacentElement('beforeend', badge);
            }
            
            if (data.total_unread > 0) {
                badge.textContent = data.total_unread;
                badge.style.display = 'inline-block';
            } else {
                badge.style.display = 'none';
            }
        }
    } catch (error) {
        console.error('Error updating notification:', error);
    }
}

// Escape HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Handle CSKH tab click
document.addEventListener('DOMContentLoaded', function() {
    const cskhTab = document.querySelector('[data-tab="cskh"]');
    if (cskhTab) {
        cskhTab.addEventListener('click', function() {
            initCSKH();
        });
    }
});
