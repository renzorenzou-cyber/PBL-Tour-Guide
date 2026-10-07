<style>
    .activation-card {
        background: #fff;
        margin-top: 100px;
        margin-left: 760px;
        margin-bottom: 150px;
        padding: 30px;
        border-radius: 16px;
        box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        max-width: 400px;
        /* margin: auto; */
        text-align: center;
        animation: bounceIn 0.8s ease;
    }
    .activation-icon {
        font-size: 50px;
        color: #87CEEB;
        margin-bottom: 15px;
        display: inline-block;
        animation: swing 2s infinite;
    }
    .activation-card h3 {
        margin: 0 0 10px;
        font-size: 1.4rem;
        color: #333;
    }
    .activation-card p {
        color: #555;
        font-size: 0.95rem;
        margin-bottom: 25px;
    }
    #resend-btn {
        background: #87CEEB;
        color: white;
        padding: 12px 20px;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        transition: all 0.3s ease;
    }
    #resend-btn:hover {
        background: #6bbcd6;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
    #resend-btn:disabled {
        background: #a0d7eb;
        cursor: not-allowed;
    }
    /* Ripple effect */
    #resend-btn::after {
        content: "";
        position: absolute;
        width: 5px;
        height: 5px;
        background: rgba(255,255,255,0.6);
        display: block;
        border-radius: 50%;
        opacity: 0;
        transform: scale(1, 1);
        transition: opacity 1s, transform 0.5s;
    }
    #resend-btn:active::after {
        opacity: 1;
        transform: scale(20, 20);
        transition: 0s;
    }
    /* Loading Spinner */
    .spinner {
        border: 3px solid rgba(255, 255, 255, 0.3);
        border-top: 3px solid #fff;
        border-radius: 50%;
        width: 16px;
        height: 16px;
        animation: spin 1s linear infinite;
        display: inline-block;
        vertical-align: middle;
        margin-right: 8px;
    }
    /* Animations */
    @keyframes bounceIn {
        0% { transform: scale(0.9); opacity: 0; }
        60% { transform: scale(1.05); opacity: 1; }
        100% { transform: scale(1); }
    }
    @keyframes swing {
        0% { transform: rotate(0deg); }
        25% { transform: rotate(8deg); }
        50% { transform: rotate(-8deg); }
        75% { transform: rotate(5deg); }
        100% { transform: rotate(0deg); }
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>

<div class="activation-card">
    <div class="activation-icon">⏳</div>
    <h3>Activation Link Expired</h3>
    <p>Your activation link has expired. Click below to resend a new one:</p>

    <form id="resend-form">
        <input type="hidden" name="email" value="{{ email }}">
        <button type="submit" id="resend-btn">Resend Activation Link</button>
    </form>
</div>

<script>
document.getElementById("resend-form").addEventListener("submit", function(e){
    e.preventDefault();
    let btn = document.getElementById("resend-btn");
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner"></span> Sending...';
    
    // Simulasi proses request
    setTimeout(() => {
        btn.innerHTML = '✅ Link Sent!';
        setTimeout(() => {
            btn.disabled = false;
            btn.innerHTML = 'Resend Activation Link';
        }, 2000);
    }, 2000);
});
</script>
