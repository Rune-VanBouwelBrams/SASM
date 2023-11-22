;
; DO NOT EDIT THIS FILE - it is used for multiple zones.
; Instead, copy it, edit named.conf, and use that copy.
;
$TTL    300
@       IN      SOA     ns.rune-vanbouwelbrams.sasm.uclllabs.be. admin.rune-vanbouwelbrams.sasm.uclllabs.be.(
			4023121549 ; Serial
                            300         ; Refresh
                            300         ; Retry
                            300         ; Expire
			    300		; Minimum TTL
)

@       IN      NS      ns.rune-vanbouwelbrams.sasm.uclllabs.be.
        IN      NS      ns1.uclllabs.be.
        IN      NS      ns2.uclllabs.be.
	IN	NS	ns.eva-rommens.sasm.uclllabs.be.

www     IN      A       193.191.176.138
ns      IN      A       193.191.176.138
test    IN      A       193.191.177.254
www1	IN	A	193.191.176.138
www2	IN	A	193.191.176.138
subzonejaew2o    IN    NS    ns.rune-vanbouwelbrams.sasm.uclllabs.be.
