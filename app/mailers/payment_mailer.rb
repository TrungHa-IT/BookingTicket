# app/mailers/payment_mailer.rb
class PaymentMailer < ApplicationMailer
  default from: 'hatrung03022003@gmail.com'

  def success_email(payment)
    @payment = payment
    @user = payment.booking.user

    mail(to: @user.email, subject: 'Thanh toán thành công') do |format|
      format.html { render 'payment_success' }  # render template HTML cho email
    end
  end
end
