import { MailerService } from '@nestjs-modules/mailer';
import { Injectable } from '@nestjs/common';
@Injectable()
export class EmailService {
  constructor(private readonly mailerService: MailerService) {}

  async sendResetPasswordEmail(email: string, token: string) {
    const validityDuration = 'an hour';

    const htmlTemplate = `
      <html>
        <head>
          <style>
            /* Add your custom CSS styles here */
            body {
              font-family: Arial, sans-serif;
              background-color: #f4f4f4;
              padding: 20px;
            }
            .container {
              max-width: 600px;
              margin: 0 auto;
              background-color: #ffffff;
              padding: 30px;
              border-radius: 5px;
              box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            h2 {
              color: #333333;
            }
            .message {
              font-size: 16px;
              color: #333333;
              margin-bottom: 20px;
            }
            .token-info {
              font-size: 14px;
              color: #666666;
              margin-top: 20px;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <h2>Forgot Password</h2>
            <p class="message">Your password reset code is: <strong>${token}</strong></p>
            <p class="token-info">This code is valid for ${validityDuration}.</p>
          </div>
        </body>
      </html>
    `;

    await this.mailerService.sendMail({
      to: email,
      from: process.env.FROM_EMAIL,
      subject: 'Forgot Password',
      html: htmlTemplate,
    });
  }
}
