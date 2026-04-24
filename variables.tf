variable "name" {
  description = "Prefix used for the generated file name."
  type        = string
  default     = "example"
}

variable "content" {
  description = "Content written into the generated file."
  type        = string
  default     = "hello, terraform test"
}