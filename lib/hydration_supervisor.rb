class HydrationSupervisor < Celluloid::SupervisionGroup
  supervise ::Actor::DateFetcher, as: :date_fetcher, args: [5]
end
