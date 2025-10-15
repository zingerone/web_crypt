// Tab switching functionality
function switchTab(tabName) {
    // Hide all tab contents
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(content => {
        content.classList.remove('active');
    });
    
    // Remove active class from all tab buttons
    const tabButtons = document.querySelectorAll('.tab-button');
    tabButtons.forEach(button => {
        button.classList.remove('active');
    });
    
    // Show selected tab content
    document.getElementById(tabName + '-tab').classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
}

// Encode text function
async function encodeText() {
    const input = document.getElementById('encode-input');
    const output = document.getElementById('encode-output');
    const button = event.target;
    
    if (!input.value.trim()) {
        showToast('Please enter text to encode', 'error');
        return;
    }
    
    // Show loading state
    const originalText = button.innerHTML;
    button.innerHTML = '<span class="loading"></span> Encoding...';
    button.disabled = true;
    
    try {
        const response = await fetch('/api/encode', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                text: input.value
            })
        });
        
        const data = await response.json();
        
        if (response.ok) {
            output.value = data.encoded;
            showToast('Text encoded successfully!', 'success');
        } else {
            showToast(data.error || 'Encoding failed', 'error');
        }
    } catch (error) {
        showToast('Network error occurred', 'error');
        console.error('Error:', error);
    } finally {
        // Reset button state
        button.innerHTML = originalText;
        button.disabled = false;
    }
}

// Decode text function
async function decodeText() {
    const input = document.getElementById('decode-input');
    const output = document.getElementById('decode-output');
    const button = event.target;
    
    if (!input.value.trim()) {
        showToast('Please enter base64 string to decode', 'error');
        return;
    }
    
    // Show loading state
    const originalText = button.innerHTML;
    button.innerHTML = '<span class="loading"></span> Decoding...';
    button.disabled = true;
    
    try {
        const response = await fetch('/api/decode', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                text: input.value
            })
        });
        
        const data = await response.json();
        
        if (response.ok) {
            output.value = data.decoded;
            showToast('Text decoded successfully!', 'success');
        } else {
            showToast(data.error || 'Decoding failed', 'error');
        }
    } catch (error) {
        showToast('Network error occurred', 'error');
        console.error('Error:', error);
    } finally {
        // Reset button state
        button.innerHTML = originalText;
        button.disabled = false;
    }
}

// Clear functions
function clearEncode() {
    document.getElementById('encode-input').value = '';
    document.getElementById('encode-output').value = '';
    showToast('Encode fields cleared', 'info');
}

function clearDecode() {
    document.getElementById('decode-input').value = '';
    document.getElementById('decode-output').value = '';
    showToast('Decode fields cleared', 'info');
}

// Copy to clipboard function
async function copyToClipboard(elementId) {
    const element = document.getElementById(elementId);
    
    if (!element.value.trim()) {
        showToast('Nothing to copy', 'error');
        return;
    }
    
    try {
        await navigator.clipboard.writeText(element.value);
        showToast('Copied to clipboard!', 'success');
    } catch (error) {
        // Fallback for older browsers
        element.select();
        document.execCommand('copy');
        showToast('Copied to clipboard!', 'success');
    }
}

// Toast notification function
function showToast(message, type = 'info') {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.className = `toast ${type}`;
    toast.classList.add('show');
    
    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

// Auto-resize textareas
function autoResize(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = textarea.scrollHeight + 'px';
}

// Add event listeners for auto-resize
document.addEventListener('DOMContentLoaded', function() {
    const textareas = document.querySelectorAll('textarea');
    textareas.forEach(textarea => {
        textarea.addEventListener('input', function() {
            autoResize(this);
        });
    });
    
    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl+Enter to encode/decode
        if (e.ctrlKey && e.key === 'Enter') {
            const activeTab = document.querySelector('.tab-content.active');
            if (activeTab.id === 'encode-tab') {
                encodeText();
            } else if (activeTab.id === 'decode-tab') {
                decodeText();
            }
        }
    });
});

// Add some example data on page load
document.addEventListener('DOMContentLoaded', function() {
    // Add placeholder examples
    const encodeInput = document.getElementById('encode-input');
    const decodeInput = document.getElementById('decode-input');
    
    if (encodeInput && !encodeInput.value) {
        encodeInput.placeholder = 'Enter text to encode...\n\nExample: Hello, World!';
    }
    
    if (decodeInput && !decodeInput.value) {
        decodeInput.placeholder = 'Enter base64 string to decode...\n\nExample: SGVsbG8sIFdvcmxkIQ==';
    }
});

// Add drag and drop functionality for files
function setupFileDrop() {
    const textareas = document.querySelectorAll('textarea');
    
    textareas.forEach(textarea => {
        textarea.addEventListener('dragover', function(e) {
            e.preventDefault();
            this.style.borderColor = '#007bff';
        });
        
        textarea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            this.style.borderColor = '#e9ecef';
        });
        
        textarea.addEventListener('drop', function(e) {
            e.preventDefault();
            this.style.borderColor = '#e9ecef';
            
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                const file = files[0];
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    textarea.value = e.target.result;
                    autoResize(textarea);
                };
                
                reader.readAsText(file);
                showToast(`File "${file.name}" loaded`, 'success');
            }
        });
    });
}

// Initialize file drop functionality
document.addEventListener('DOMContentLoaded', setupFileDrop);
