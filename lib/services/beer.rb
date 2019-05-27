module Services
  class Beer
    include Import[repo: 'repositories.beer_repo']

    THROTTLING_BEER_TIMEOUT = 60 * 5 # 5 minutes

    SCALE_OF_DRUNKNESS = {
      1 => ['In Russia we say: mezdu pervoi i vtoroi pererivchik nebolshoi', '*Good start!*'],
      2 => ['️*While you were finishing this beer - I was downd my third glass*', '*I hope you got here by bus?*'],
      3 => ['*Now it is time to pee*', '*Time to discuss the last GOT*'],
      4 => ['*The good, the bad and the fourth glass*', '*What do you think about karaoke bar?*'],
      5 => ['*How many fingers are there?*', '*Time to call your ex*'],
      6 => ['*Friendly reminder: in Saint-Petersburg the bridges are rised at night*', '*Are you ok, buddy?*'],
      7 => ['*Remember your first glass? Neither do I*', '*I think it is time to get hard stuff*'],
      8 => ['*Now I leave your alone with your beer, YOU WON!*']
    }

    def drink(user_id)
      repo.create(user_id: user_id, drunk_at: Time.now)
    end

    def last(user_id)
      repo.find_by_user_id(user_id).drunk_at.last
    end

    def user_total(user_id)
      repo.find_by_user_id(user_id).drunk_at.count
    end

    def total
      repo.all.map do |drunk_beer|
        drunk_beer.drunk_at.count
      end.reduce(:+)
    end

    def drinks_fast?(user_id)
      (last(user_id) + THROTTLING_BEER_TIMEOUT) > Time.now
    end

    def scale_of_drunkness(user_id)
      scale = SCALE_OF_DRUNKNESS[user_total(user_id)]
      return '*Sorry man, I am too drunk. Count it yourself*' if scale.nil?
      scale.sample
    end
  end
end
