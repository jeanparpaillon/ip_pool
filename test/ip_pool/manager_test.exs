defmodule IpPool.Manager do
  use ExUnit.Case

  @pool4_27 {{88, 23, 65, 224}, 27}
  @pool6_56 {{0x2001, 0x41D0, 0x009A, 0x0A00, 0, 0, 0, 0}, 56}

  setup ctx do
    {:ok, _} =
      IpPool.Manager.start_link([
        @pool4_27,
        @pool6_56
      ])

    {:ok, ctx}
  end

  test "Lease on /27 IPv4 pool", _ctx do
    # 30 * different /32 IP available
    leases =
      0..29
      |> Enum.reduce(MapSet.new(), fn _, acc ->
        lease = IpPool.Manager.lease(@pool4_27)
        assert lease != nil
        MapSet.put(acc, lease)
      end)

    assert MapSet.size(leases) == 30

    # No more leases
    assert IpPool.Manager.lease(@pool4_27) == nil
  end

  test "Lease on /56 IPv6 pool", _ctx do
    # 256 * different /64 IP available
    leases =
      0..255
      |> Enum.reduce(MapSet.new(), fn _, acc ->
        lease = IpPool.Manager.lease(@pool6_56, mask: 64)
        assert lease != nil
        MapSet.put(acc, lease)
      end)

    assert MapSet.size(leases) == 256

    # No more leases
    assert IpPool.Manager.lease(@pool6_56) == nil
  end

  test "Release not leased block" do
    refute IpPool.Manager.release({{192, 68, 54, 2}, 23})
  end

  test "Release leased block" do
    lease = IpPool.Manager.lease(@pool4_27, mask: 30)
    assert IpPool.Manager.release(lease)
  end

  doctest IpPool.Manager
end
