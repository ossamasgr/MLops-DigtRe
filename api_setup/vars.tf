# Resource Groupe
variable "RG" {
  description = ""
  type        = string
  default     = "mlops-RG"
}
# Api Management Name
variable "APIM" {
  description = ""
  type        = string
  default     = "api-mlops"
}
# Service URL
variable "URL" {
  description = ""
  type        = string
  default     = "http://10.224.0.8:5000/"
}
# API Name
variable "api_name" {
  description = ""
  type        = string
  default     = "terraform-api2"
}
