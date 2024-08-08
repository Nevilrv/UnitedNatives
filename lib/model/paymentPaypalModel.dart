class PaypalPaymentModel {
  var patientId;
  var doctorId;
  var purposeOfVisit;
  var appointmentDate;
  var appointmentTime;
  var appointmentFor;
  var fullName;
  var mobile;
  var email;
  var patientMobile;
  var doctorFees;
  String? firstName;
  String? lastName;
  String? city;
  String? state;
  String? companyName;
  String? providerName;
  String? faxNumber;

  PaypalPaymentModel({
    this.patientId,
    this.doctorId,
    this.purposeOfVisit,
    this.appointmentDate,
    this.appointmentTime,
    this.appointmentFor,
    this.fullName,
    this.mobile,
    this.email,
    this.patientMobile,
    this.doctorFees,
    this.firstName,
    this.lastName,
    this.city,
    this.state,
    this.companyName,
    this.providerName,
    this.faxNumber,
  });
}
