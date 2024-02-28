import { MailerService } from '@nestjs-modules/mailer';
import { Injectable } from '@nestjs/common';
@Injectable()
export class EmailService {
  constructor(private readonly mailerService: MailerService) {}

  async sendResetPasswordEmail(email: string, token: string) {
    await this.mailerService.sendMail({
      to: email,
      from: process.env.FROM_EMAIL,
      subject: 'Forgot Password',
      text: `Your password reset code is: ${token}`,
    });
  }
}