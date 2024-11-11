import argparse
import collections
import operator
import socket
import sys

__author__ = 'rick'
description = """
A short description of the program.
"""
epilog = """
This text is presented below the arguments, it is a good place to list assumptions, requirements, side effects
or discussions of the program.  If this text here is already formatted see the argparse.RawDescriptionHelpFormatter in
http://docs.python.org/library/argparse.html#formatter-class
"""

class UfwEntry(object):
    def __init__(self, input_iface=None, output_iface=None, src=None, dest=None, tos=None, prec=None,
                 ttl=None, proto=None, spt=None, dpt=None):
        self.input_iface = input_iface
        self.output_iface = output_iface
        self.src = src
        self.dest = dest
        self.tos = tos
        self.prec = prec
        self.ttl = ttl
        self.proto = proto
        self.spt = spt
        self.dpt = dpt


def count_source_ports(ufw_entries):
    """ Given an collection of UfwEntries, return a collections.Counter keyed on the source port, with number of occurrences of the source port in the value."""
    source_ports = collections.Counter()
    for ufw_entry in ufw_entries:
        source_ports[ufw_entry.spt] += 1

    return source_ports

def count_dest_ports(ufw_entries):
    """ Given an collection of UfwEntries, return a collections.Counter keyed on the destination port, with number of occurrences of the destination port in the value."""
    dest_ports = collections.Counter()
    for ufw_entry in ufw_entries:
        dest_ports[ufw_entry.dpt] += 1

    return dest_ports

if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(description=description, epilog=epilog)

    arg_parser.add_argument("-o", "--outfile", help="The file to write to")
    arg_parser.add_argument("-n", "--number_of_entries", type=int, help="The most prevalent N entries for each table")

    arg_parser.add_argument("ufw_log")
    args = arg_parser.parse_args()

    if args.outfile is None:
        outfile = sys.stdout
    else:
        outfile = open(args.outfile, "w")

    if args.number_of_entries is None:
        number_of_entries = 0
    else:
        number_of_entries = args.number_of_entries

    npt = 10
    
    with open(args.ufw_log, "r") as ufwlog:
        ip  = dict()
        ip_src = dict()
        ip_dest = dict()

        for line in ufwlog:
            # Feb 27 07:57:36 muddy kernel: [951426.354327] [UFW BLOCK] IN=eth0 OUT=eth1 SRC=192.168.8.2
            # DST=74.126.6.130 LEN=40 TOS=0x00 PREC=0x00 TTL=127 ID=30467 DF PROTO=TCP SPT=51603 DPT=80 WINDOW=16224
            # RES=0x00 ACK FIN URGP=0


            tokens = line.split(" ")
            idx = -1
            for token in tokens:
                if token.startswith("IN="):
                    input_iface = token[3:]
                    continue
                if token.startswith("OUT="):
                    output_iface = token[4:]
                    continue
                if token.startswith("SRC="):
                    src = token[4:]
                    continue
                if token.startswith("DST="):
                    dest = token[4:]
                    continue
                if token.startswith("TOS="):
                    tos = token[4:]
                    continue
                if token.startswith("PREC="):
                    prec = token[5:]
                    continue
                if token.startswith("TTL="):
                    ttl = token[idx][4:]
                    continue
                if token.startswith("PROTO="):
                    proto = token[6:]
                    continue
                if token.startswith("SPT="):
                    spt = token[4:]
                    continue
                if token.startswith("DPT="):
                    dpt = token[4:]
                    continue


            ufw_entry = UfwEntry(input_iface, output_iface, src, dest, tos, prec, ttl, proto, spt, dpt)
            ip_src.setdefault(src, []).append(ufw_entry)
            ip_dest.setdefault(dest, []).append(ufw_entry)

    ip_src_cnt = collections.OrderedDict()
    for src, ufw_entries in ip_src.iteritems():
        ip_src_cnt[src] = len(ufw_entries)
    sorted_by_src_count = sorted(ip_src_cnt.iteritems(), key=operator.itemgetter(1))

    ip_dest_cnt = collections.OrderedDict()
    for dest, ufw_entries in ip_dest.iteritems():
        ip_dest_cnt[dest] = len(ufw_entries)
    sorted_by_dest_count = sorted(ip_dest_cnt.iteritems(), key=operator.itemgetter(1))


    sys.stderr.write("search for source hostnames, this can take a while because of name resolution...\n")
    outfile.write("By source:\n")
    outfile.write("=" * 80 + "\n")
    n_sorted_by_src_count = len(sorted_by_src_count)
    if number_of_entries > 0 and number_of_entries < n_sorted_by_src_count:
        idx_list = range(-number_of_entries, 0)
    else:
        idx_list = range(0, n_sorted_by_src_count)


    for idx in idx_list:
        ip_address, count = sorted_by_src_count[idx]
        source_ports = count_source_ports(ip_src[ip_address])
        dest_ports = count_dest_ports(ip_src[ip_address])
        try:
            tup = socket.gethostbyaddr(ip_address)
            hostname = tup[0]
        except socket.error:
            hostname = "unknown"
        outfile.write("{} {}  {}  ".format(ip_address, hostname, count))
        outfile.write("  spt  ")
        for spt, cnt in source_ports.most_common(npt):
            outfile.write("{}:{},  ".format(spt, cnt))
        # outfile.write("\n")
        outfile.write("  dest ")
        for dpt, cnt in dest_ports.most_common(npt):
            outfile.write("{}:{},  ".format(dpt, cnt))
        outfile.write("\n")

    sys.stderr.write("search for destination hostnames, this can take a while because of name resolution...\n")
    outfile.write("\n\nBy destination:\n")
    outfile.write("=" * 80 + "\n")
    if number_of_entries > 0:
        idx_list = range(-number_of_entries, 0)
    else:
        idx_list = range(0, len(sorted_by_dest_count))

    for idx in idx_list:
        ip_address, count = sorted_by_dest_count[idx]
        source_ports = count_source_ports(ip_dest[ip_address])
        dest_ports = count_dest_ports(ip_dest[ip_address])
        try:
            tup = socket.gethostbyaddr(ip_address)
            hostname = tup[0]
        except socket.error:
            hostname = "unknown"

        outfile.write("{} {}  {}  ".format(ip_address, hostname, count))
        outfile.write("  spt  ")
        for spt, cnt in source_ports.most_common(npt):
            outfile.write("{}:{},  ".format(spt, cnt))
        #outfile.write("\n")
        outfile.write("  dest ")
        for dpt, cnt in dest_ports.most_common(npt):
            outfile.write("{}:{},  ".format(dpt, cnt))
        outfile.write("\n")

    outfile.close()