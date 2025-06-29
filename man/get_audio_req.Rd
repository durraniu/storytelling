% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_audio.R
\name{get_audio_req}
\alias{get_audio_req}
\title{Convert text to speech}
\usage{
get_audio_req(
  text,
  ACCOUNT_ID = Sys.getenv("CLOUDFLARE_ACCOUNT_ID"),
  API_KEY = Sys.getenv("CLOUDFLARE_API_KEY")
)
}
\arguments{
\item{text}{Text to be converted to speech}

\item{ACCOUNT_ID}{Cloudflare Workers AI Model API account ID}

\item{API_KEY}{Cloudflare Workers AI Model API key}
}
\value{
httr2 request.
}
\description{
Convert text to speech
}
