def call(process, request, timeout) do
  monitor = Process.monitor(process)
  send(process, {:"$gen_call", {self(), monitor}, request})

  receive
    {^monitor, reply} ->
      Process.demonitor(monitor, [:flush])
      {:ok, reply}
    {:DOWN, ^monitor, _, _, reason} ->
      {:error, reason}
  after timeout ->
    Process.demonitor(monitor, [:flush])
    {:error, :timeout}
  end
end
