# =============================================================================
# Part 1: HTTP and httr2 Refresher
# Collecting Data: Web, APIs, Open Sources — E1493, Data Journalism, Simon Munzert
# =============================================================================

library(httr2)

# -----------------------------------------------------------------------------
# httr2 basics: build → modify → perform → extract
# -----------------------------------------------------------------------------

resp <- request("https://api.genderize.io") |>  # base URL
  req_url_query(name = "Anna") |>               # add ?name=Anna
  req_headers(Accept = "application/json") |>   # set a header
  req_timeout(10) |>                            # fail after 10s
  req_perform()                                 # fire the request

# Inspect the response
resp_status(resp)       # 200
resp_content_type(resp) # "application/json"
resp_headers(resp)      # all response headers

# Extract the body
resp_body_string(resp)  # raw JSON string
resp_body_json(resp)    # parsed into R list

# -----------------------------------------------------------------------------
# Reading response headers
# -----------------------------------------------------------------------------

# Single header
resp |> resp_header("Content-Type")

# All headers as a named list
resp |> resp_headers()


# =============================================================================
# Exercises
# =============================================================================

# -----------------------------------------------------------------------------
# Exercise 1 (easy) — Inspect a response with httpbin
# httpbin.org echoes back whatever request you send it.
# Send a GET request with two query parameters of your choice and inspect the
# result. What does $args contain? What user-agent does R report?
# -----------------------------------------------------------------------------

resp <- request("https://httpbin.org/get") |>
  req_url_query(city = "Berlin", year = 2025) |>
  req_perform()

resp_status(resp)
body <- resp_body_json(resp)
body$args
body$headers[["User-Agent"]]

# -----------------------------------------------------------------------------
# Exercise 2 (intermediate) — Send a POST request with a JSON body
# Some APIs use POST with data in the request body instead of the URL.
# Use req_body_json() to POST a payload to httpbin. Which field in the response
# contains your data? What Content-Type did httr2 set automatically?
# -----------------------------------------------------------------------------

resp <- request("https://httpbin.org/post") |>
  req_body_json(list(name = "Anna", country = "DE", year = 2025)) |>
  req_perform()

body <- resp_body_json(resp)
body$json
body$headers[["Content-Type"]]
