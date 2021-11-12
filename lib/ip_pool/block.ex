defmodule IpPool.Block do
  @moduledoc """
  Describe a IP addresses block (v4, v6)
  """
  require Record
  alias IpPool.Pool

  Record.defrecord(:block, id: nil, pool: nil, status: :free)

  @type id :: {:inet.ip_address(), integer}
  @type status :: :free | :partial | :lease | :reserved
  @type t :: record(:block, id: id, pool: Pool.id(), status: status)
end
