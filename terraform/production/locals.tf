locals {
  caa_record_tags                                = ["issue", "issuewild"]
  hamradionewbie_com_github_pages_ipv4_addresses = ["185.199.108.153", "185.199.109.153", "185.199.110.153", "185.199.111.153"]
  hamradionewbie_com_github_pages_ipv6_addresses = ["2606:50c0:8000::153", "2606:50c0:8001::153", "2606:50c0:8002::153", "2606:50c0:8003::153"]
  loganandmaria_mx_records = [
    { priority = 1, content = "aspmx.l.google.com" },
    { priority = 5, content = "alt1.aspmx.l.google.com" },
    { priority = 5, content = "alt2.aspmx.l.google.com" },
    { priority = 10, content = "alt3.aspmx.l.google.com" },
    { priority = 10, content = "alt4.aspmx.l.google.com" },
    { priority = 15, content = "gubaxfbs3pclxek6tkmakpeeye2l2tveafmdf5xkhumda67hws4q.mx-verification.google.com" }
  ]
}
