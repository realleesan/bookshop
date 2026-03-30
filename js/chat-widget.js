// Chat Widget JavaScript
let chatWidget = null;
let chatInterval = null;

// Initialize chat widget
function initChatWidget() {
    const chatHTML = `
        <div class="chat-widget">
            <div class="chat-toggle-btn" onclick="toggleChat()" title="Chat với chúng tôi">
                <i class="fa-light fa-comments"></i>
            </div>
            <div class="chat-notification" id="chatNotification">0</div>
            <div class="chat-container" id="chatContainer">
                <div class="chat-header">
                    <h3>Hỗ trợ khách hàng</h3>
                    <button class="chat-close-btn" onclick="toggleChat()">
                        <i class="fa-light fa-xmark"></i>
                    </button>
                </div>
                <div class="chat-messages" id="chatMessages">
                    <div class="chat-empty">Hãy gửi tin nhắn để bắt đầu cuộc trò chuyện</div>
                </div>
                <div class="chat-input-area">
                    <textarea class="chat-input" id="chatInput" placeholder="Nhập tin nhắn..." 
                        onkeydown="handleChatKeyDown(event)"></textarea>
                    <button class="chat-send-btn" id="chatSendBtn" onclick="sendChatMessage()">
                        <i class="fa-light fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', chatHTML);
    chatWidget = document.getElementById('chatContainer');
    
    // Load chat history when widget is opened
    loadChatHistory();
}

// Toggle chat widget visibility
function toggleChat() {
    const container = document.getElementById('chatContainer');
    const btn = document.querySelector('.chat-toggle-btn');
    
    if (container.classList.contains('chat-active')) {
        container.classList.remove('chat-active');
        btn.classList.remove('chat-open');
    } else {
        container.classList.add('chat-active');
        btn.classList.add('chat-open');
        loadChatHistory();
    }
}

// Get current user ID from localStorage
function getCurrentUserId() {
    const currentUser = localStorage.getItem('currentuser');
    if (currentUser) {
        const user = JSON.parse(currentUser);
        return user.id || user.phone || null;
    }
    return null;
}

// Load chat history
async function loadChatHistory() {
    const userId = getCurrentUserId();
    if (!userId) {
        showChatEmpty('Vui lòng đăng nhập để chat');
        return;
    }
    
    try {
        const response = await fetch(`api/chat_get_messages.php?user_id=${userId}`);
        const messages = await response.json();
        
        if (messages.error) {
            showChatEmpty('Không thể tải tin nhắn');
            return;
        }
        
        renderChatMessages(messages);
    } catch (error) {
        console.error('Error loading chat:', error);
        showChatEmpty('Lỗi kết nối');
    }
}

// Render chat messages
function renderChatMessages(messages) {
    const messagesContainer = document.getElementById('chatMessages');
    
    if (!messages || messages.length === 0) {
        messagesContainer.innerHTML = '<div class="chat-empty">Hãy gửi tin nhắn để bắt đầu cuộc trò chuyện</div>';
        return;
    }
    
    messagesContainer.innerHTML = messages.map(msg => {
        const time = new Date(msg.created_at).toLocaleTimeString('vi-VN', { 
            hour: '2-digit', 
            minute: '2-digit' 
        });
        
        return `
            <div class="chat-message ${msg.sender_type}">
                <div class="message-bubble">
                    ${escapeHtml(msg.message)}
                    <div class="message-time">${time}</div>
                </div>
            </div>
        `;
    }).join('');
    
    // Scroll to bottom
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

// Show empty chat message
function showChatEmpty(message) {
    const messagesContainer = document.getElementById('chatMessages');
    messagesContainer.innerHTML = `<div class="chat-empty">${message}</div>`;
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Handle enter key in chat input
function handleChatKeyDown(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
        event.preventDefault();
        sendChatMessage();
    }
}

// Send chat message
async function sendChatMessage() {
    const input = document.getElementById('chatInput');
    const message = input.value.trim();
    const sendBtn = document.getElementById('chatSendBtn');
    
    const userId = getCurrentUserId();
    if (!userId) {
        alert('Vui lòng đăng nhập để gửi tin nhắn');
        return;
    }
    
    if (!message) return;
    
    // Disable button while sending
    sendBtn.disabled = true;
    
    try {
        const response = await fetch('api/chat_send.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                user_id: userId,
                message: message,
                sender_type: 'user'
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            input.value = '';
            loadChatHistory();
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

// Poll for new messages (for real-time updates)
function startChatPolling() {
    if (chatInterval) clearInterval(chatInterval);
    
    chatInterval = setInterval(() => {
        const container = document.getElementById('chatContainer');
        if (container && container.classList.contains('chat-active')) {
            loadChatHistory();
        }
    }, 5000);
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', function() {
    initChatWidget();
    startChatPolling();
});
