class Census

  URL = 'http://api.usatoday.com/open/census/ethnicity'

  SUM_LEV_ID = {
    national: 1,
    state: 2,
    county: 3,
    city: 6
  }

  params = {sumlevid: SUM_LEV_ID[:state]}

  def process(params)
    Net::Service.send_get(URL, params)['response'].each do |e|
      Ethnicity.create!({
        placename: e["Placename"],
        location: e["StatePostal"],
        sumlevid: params[:sumlevid],
        pct_hisp: e["PctHisp"].to_f,
        pct_non_hisp_white: e["PctNonHispWhite"].to_f,
        diversity_index: e["USATDiversityIndex"].to_f,
        fips: e["FIPS"].to_i,
        gnis: e["GNIS"].to_i
      })
    end
  end

end
