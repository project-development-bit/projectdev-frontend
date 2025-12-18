const registerEndpoints = 'users';
const loginEndpoints = 'users/login';
const resendCodeEndpoints = 'users/resend-code';
const forgetPasswordResendCodeEndpoints = 'users/resend-forgot-password-code';
const forgetPasswordVerifyCodeEndpoints = 'users/verify-forgot-password';
const verifyCodeEndpoints = 'users/verify'; // POST with /{email}/{code}
const verify2FAEndpoints = 'users/verify-2fa'; // POST with 2FA code
const verifyLogin2FAEndpoints =
    '2fa/verify-login'; // POST to verify 2FA during login
const setup2FAEndpoints = '2fa/setup'; // POST to setup 2FA
const enable2FAEndpoints = '2fa/verify'; // POST to enable 2FA
const check2FAStatusEndpoints = '2fa/status'; // GET to check 2FA status
const disable2FAEndpoints = '2fa/disable'; // POST to disable 2FA
const forgotPasswordEndpoints = 'users/forgot_password';
const savePasswordEndpoints = 'users/save_password';
const whoamiEndpoints = 'users/whoami';

// Fortune Wheel Endpoints
const fortuneWheelRewardsEndpoint =
    'fortune-wheel/rewards'; // GET fortune wheel rewards
const fortuneWheelSpinEndpoint =
    'fortune-wheel/spin'; // POST spin fortune wheel
const fortuneWheelStatusEndpoint =
    'fortune-wheel/rewards/status'; // GET fortune wheel status
