variable "ami" {
  type = "string"
  description = "a AMI que sera utilizada"
  default = "ami-3885d854"
}

variable "instance" {
  type = "string"
  description = "O Tipo de instancia que sera utilizada"
  default = "t2.micro"
}

variable "port" {
  description = "Porta que sera usada nos servidores web"
  default  = 8080
}