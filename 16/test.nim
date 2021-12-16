import main
import unittest

suite "Day 16":
  test "parsePacketData1":
    let p = "D2FE28".parsePacketData
    check p.version == 6
    check p.id == 4
    check p.literal == 2021

  test "parsePacketData2":
    let p = "38006F45291200".parsePacketData
    check p.version == 1
    check p.id == 6
    check p.subpackets.len == 2
    check p.subpackets[0].literal == 10
    check p.subpackets[1].literal == 20

  test "parsePacketData3":
    let p = "EE00D40C823060".parsePacketData
    check p.version == 7
    check p.id == 3
    check p.subpackets.len == 3
    check p.subpackets[0].literal == 1
    check p.subpackets[1].literal == 2
    check p.subpackets[2].literal == 3

  test "parsePacketData4":
    let p1 = "A0016C880162017C3686B18A3D4780".parsePacketData
    check p1.subpackets.len == 1
    let p2 = p1.subpackets[0]
    check p2.subpackets.len == 1
    let p3 = p2.subpackets[0]
    check p3.subpackets.len == 5

  test "part1":
    check "8A004A801A8002F478".parsePacketData.part1 == 16
    check "620080001611562C8802118E34".parsePacketData.part1 == 12
    check "C0015000016115A2E0802F182340".parsePacketData.part1 == 23
    check "A0016C880162017C3686B18A3D4780".parsePacketData.part1 == 31

  test "part2":
    check "C200B40A82".parsePacketData.part2 == 3
    check "04005AC33890".parsePacketData.part2 == 54
    check "880086C3E88112".parsePacketData.part2 == 7
    check "CE00C43D881120".parsePacketData.part2 == 9
    check "D8005AC2A8F0".parsePacketData.part2 == 1
    check "F600BC2D8F".parsePacketData.part2 == 0
    check "9C005AC2F8F0".parsePacketData.part2 == 0
    check "9C0141080250320F1802104A08".parsePacketData.part2 == 1
