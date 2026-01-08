# Notify.lk SMS Gateway Setup

## Required Environment Variables

Add the following environment variables to your `.env` file:

```env
NOTIFY_LK_USER_ID=your_user_id_here
NOTIFY_LK_API_KEY=your_api_key_here
NOTIFY_LK_SENDER_ID=your_sender_id_here
```

## How to Get Your Credentials

1. Log in to your Notify.lk account at https://app.notify.lk
2. Go to the "API Keys" section in your account settings
3. Copy your **User ID** and **API Key**
4. For **Sender ID**, use:
   - `NotifyDEMO` for testing (case sensitive)
   - Your approved Sender ID for production

## Important Notes

- The `NotifyDEMO` sender ID is for testing only. Do not use it for OTP content.
- For production, you must get your own Sender ID approved first.
- Phone numbers should be in the format: `9471XXXXXXX` (without + sign)
- SMS messages are limited to 621 characters

## Testing

After adding the credentials to your `.env` file, test the SMS functionality by:
1. Activating SOS from the mobile app
2. Checking the SOS Alerts section in the web app
3. Verifying SMS delivery status




