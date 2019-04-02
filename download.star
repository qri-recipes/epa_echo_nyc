# script to grab facility data from EPA ECHO:
# https://echo.epa.gov/tools/web-services/facility-search-all-data#!/Facility_Info/get_echo_rest_services_get_download
load("http.star", "http")
load("encoding/csv.star", "csv")


# download is a special function called by Qri to get data
def download(ctx):
  metadata = get_metadata()

  # search for facilities within 5 miles of New York City
  facility_stats = get_geo_facilities(40.730610, -73.935242, 5)

  # for easier debugging, try using the print function to show data
  # print(facility_stats, "\n")

  facility_data = get_download(facility_stats["QueryID"])

  return {
    "metadata" : metadata,
    "facility_stats": facility_stats,
    "facility_data": facility_data,
  }

# transform is a special function called by Qri, the passed in 'ds' is an empty
# dataset, any changes to ds will be saved
def transform(ds, ctx):
  
  ds.set_meta("title", "EPA ECHO Facilities Within 5 Miles of New York City")
  ds.set_meta("description", "Uses the US Environmental Protection Agency (EPA) Enforcement And Compliance Online (ECHO) search API to fetch factilities within 5 miles of New York City")
  # ctx.download is the value returned from calling the download function
  ds.set_meta("stats", ctx.download["facility_stats"])

  ds.set_structure(generate_structure(ctx.download["metadata"], ctx.download["facility_data"]))

  ds.set_body(ctx.download["facility_data"], data_format="csv", raw=True)



"""
Helper Functions:
"""

# base url for ECHO API
base_url = "https://ofmpub.epa.gov/echo"

def get_metadata():
  url = "%s/echo_rest_services.metadata?output=JSON" % (base_url)
  res = http.get(url)
  return res.json()["Results"]["ResultColumns"]

def get_geo_facilities(lat,lng, radius):
  url = "%s/echo_rest_services.get_facilities?output=JSON&p_lat=%f&p_long=%f&p_radius=%d" % (base_url, lat, lng, radius)
  res = http.get(url)
  return res.json()["Results"]

def get_download(qid):
  url = "%s/echo_rest_services.get_download?output=CSV&qid=%s" % (base_url, qid)
  res = http.get(url)
  return res.body()

# generate_structure binds results from API metadata to the returned header row,
# creating a qri dataset structure with schema descriptions
def generate_structure(metadata, data):
  # read off the header row
  header = csv.read_all(data,lazy_quotes=True)[0]
  columns = []

  for name in header:
    for m in metadata:
      if m["ObjectName"] == name:
        col = {
          "title": name,
          "type": "string",
          "description": m["Description"],
        }

        # handle numeric
        if m["DataType"] == "NUMBER":
          col["type"] = "number"
        columns.append(col)
        break

  return {
    "format": "csv",
    "formatConfig": {
      "headerRow": True,
      "lazyQuotes": True
    },
    "schema": {
      "type": "array",
      "items": {
        "type": "array",
        "items": columns,
      }
    }
  }
