locals {
  caa_record_tags                                = ["issue", "issuewild"]
  hamradionewbie_com_github_pages_ipv4_addresses = ["185.199.108.153", "185.199.109.153", "185.199.110.153", "185.199.111.153"]
  hamradionewbie_com_github_pages_ipv6_addresses = ["2606:50c0:8000::153", "2606:50c0:8001::153", "2606:50c0:8002::153", "2606:50c0:8003::153"]
  loganandmaria_mx_records = [
    { priority = 1, content = "ASPMX.L.GOOGLE.COM" },
    { priority = 5, content = "ALT1.ASPMX.L.GOOGLE.COM" },
    { priority = 5, content = "ALT2.ASPMX.L.GOOGLE.COM" },
    { priority = 10, content = "ALT3.ASPMX.L.GOOGLE.COM" },
    { priority = 10, content = "ALT4.ASPMX.L.GOOGLE.COM" },
    { priority = 15, content = "gubaxfbs3pclxek6tkmakpeeye2l2tveafmdf5xkhumda67hws4q.mx-verification.google.com" }
  ]
}
