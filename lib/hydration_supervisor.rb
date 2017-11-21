class HydrationSupervisor < Celluloid::SupervisionGroup
  supervise ::Actor::DateFetcher, as: :date_fetcher, args: [5]
  supervise ::Actor::ThumbnailFetcher, as: :thumbnail_fetcher, args: [5]
  supervise ::Actor::TitleFetcher, as: :title_fetcher, args: [5]
end
