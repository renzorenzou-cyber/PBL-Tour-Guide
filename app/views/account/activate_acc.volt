<div style="
    display: flex; 
    justify-content: center; 
    align-items: center; 
    min-height: 70vh; 
    background-color: #fafafafa; 
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
    color: #333; 
    text-align: center;
">
    <div style="
        padding: 30px; 
        background-color: #ffffff; 
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1); 
        border-radius: 12px; 
        max-width: 400px; 
        animation: bounceIn 0.6s ease forwards;
    ">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="80" height="80" style="fill: #87CEEB; margin-bottom: 20px; animation: pulse 1.2s infinite;margin-left:10px;">
            <path d="M12 0C5.373 0 0 5.373 0 12s5.373 12 12 12 12-5.373 12-12S18.627 0 12 0zm-1.2 17.6l-5-5 1.4-1.4 3.6 3.6 7.6-7.6 1.4 1.4-9 9z"/>
        </svg>
        <h1 style="color: #000; font-size: 24px; margin: 0;">Your Account Has Been Activated!</h1>
        <p style="font-size: 16px; margin: 10px 0 20px;">Welcome to Tropialis</p>
        
        <a href="{{ url() }}/account/login/" style="
            display: inline-block; 
            margin-top: 20px; 
            padding: 10px 24px; 
            background-color: #87CEEB; 
            color: #fff; 
            text-decoration: none; 
            border-radius: 5px; 
            font-size: 16px; 
            transition: background-color 0.3s, transform 0.2s;
        " onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">
            Back to Login Page
        </a>

    </div>
</div>

<style>
    @keyframes bounceIn {
        0% { opacity: 0; transform: scale(0.8) translateY(20px); }
        60% { opacity: 1; transform: scale(1.05) translateY(-10px); }
        80% { transform: scale(0.95) translateY(5px); }
        100% { transform: scale(1) translateY(0); }
    }

    @keyframes pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.1); }
    }

    
</style>
<input type="hidden" id="paymenturl" value="{{ paymenturl }}" />