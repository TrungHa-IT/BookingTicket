class PaymentMailer < ApplicationMailer
  default from: 'cinema@gmail.com'

  def success_email(payment)
    @payment = payment
    @user = payment.booking.user
    @show   = payment.booking.show  
    @seats  = payment.booking.seats 
    @show_time_detail = payment.booking.booking_seats.first&.show_time_detail

    require 'rqrcode'
    qr = RQRCode::QRCode.new("PAYMENT-#{payment.id}")

    png = qr.as_png(size: 200)

    attachments.inline['qr_code.png'] = png.to_s

    mail(to: @user.email, subject: 'Vé xem phim - Thanh toán thành công')
  end
end
