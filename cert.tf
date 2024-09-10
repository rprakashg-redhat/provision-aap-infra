provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "aws_route53_zone" "base_domain" {
  name = var.config.base_domain
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "ram.gopinathan@redhat.com" 
}

resource "acme_certificate" "acme" {
    account_key_pem           = acme_registration.registration.account_key_pem
    common_name               = data.aws_route53_zone.base_domain.name
    subject_alternative_names = ["automation.${data.aws_route53_zone.base_domain.name}"]

    dns_challenge {
        provider = "route53"

        config = {
            AWS_HOSTED_ZONE_ID = data.aws_route53_zone.base_domain.zone_id
        }
    }
}

# store the generated certs in Amazon Certificate Manager
resource "aws_acm_certificate" "cert" {
    certificate_body = acme_certificate.acme.certificate_pem 
    private_key = acme_certificate.acme.private_key_pem
    certificate_chain = acme_certificate.acme.issuer_pem
}

resource local_file "cert_file" {
  filename = "${path.module}/certs/aapcert.pem"
  content = "${acme_certificate.acme.certificate_pem}\n${acme_certificate.acme.issuer_pem}"
}

resource "local_file" "cert_key_file" {
  filename = "${path.module}/certs/aapcert_private_key.pem"
  content = acme_certificate.acme.private_key_pem
}