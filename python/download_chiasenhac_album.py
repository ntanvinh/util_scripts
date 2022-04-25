import requests
from parsel import Selector
from pathlib import Path
import os
import sys

def show_help():
    print("""
    this_script chiasenhac_album_url [extention] [download_location]

    Parameters:
    chiasenhac_album_url: URL of ChiaSeNhac album.
    extention [optional]: mp3 or flac. Default is mp3 (320 kbps).
    download_location [optional]: folder to save downloaded album. Default is Downloads folder of current user.

    """)

args = sys.argv
if len(args) == 1:
    print("Please input album ChiaSeNhac album URL")
    show_help()
    sys.exit()

album_url_arg = args[1]
try:
    song_ext_arg = args[2]
except:
    song_ext_arg = None
try:
    download_location_arg = args[3]
except:
    download_location_arg =None

# login cookie for download flac. If not use the cookie, user can only download 128 kbps mp3 file
cookies = {"chia_se_nhac_session": "eyJpdiI6Im5lXC9hTEdNcnVUbDNEVmRrUm96YjVRPT0iLCJ2YWx1ZSI6ImtqYUJxdjdwSUtRRFdvMnhhOXU2Rms5eVBzWmZ1b0xmOXJpcml6a090RHB5eVZ2amNtWUYrbXptXC82N0hWUzFDIiwibWFjIjoiOWJlN2FjZWY5NGU4OTk3MDg3NzA5MDhlOWZjMmY0ZThiZDZmOGY1NDU3MThjODE1YzdhODZmMzE5NmZmOGYzYiJ9"}

# parameters
album_url = album_url_arg or "https://chiasenhac.vn/nghe-album/golden-music-of-richard-claydermandenver-music-orchestra-xssmmstzq884f1.html"
song_ext = song_ext_arg or "mp3"  # "flac" or "mp3"
download_location = download_location_arg or os.path.join(str(Path.home()), "Downloads")

# get song page urls
album_res = requests.get(album_url)
album_page = Selector(text=album_res.text)
album_name = album_page.xpath("//span[contains(text(), 'Album')]/following-sibling::a/text()").extract_first()
song_page_urls = album_page.xpath(
    '//div[@class="name d-table-cell"]/a[@href]/@href').extract()

total_songs = len(song_page_urls)
for index, song_page_url in enumerate(song_page_urls):
    song_page_res = requests.get(song_page_url, cookies=cookies)

    song_page = Selector(text=song_page_res.text)
    song_download_url = song_page.xpath(
        f'//a[contains(@href, ".{song_ext}")]/@href').extract()[-1] # last item with mp3 link has highest quality 320
    # file_name = requests.utils.unquote(song_download_url).split("/")[-1]
    song_name = song_page.xpath('//h2[@class="card-title"]/text()').extract_first()
    artist_name = song_page.xpath("//span[contains(text(), 'Ca sĩ')]/following-sibling::a/text()").extract_first()

    print(f"[{index+1}/{total_songs}] downloading song {song_download_url}")
    song = requests.get(song_download_url)

    file_name = f"{song_name} - {artist_name}.{song_ext}"
    full_path_song = os.path.join(download_location, album_name, file_name)
    # create album folder if not existed
    os.makedirs(os.path.dirname(full_path_song), exist_ok=True)

    open(full_path_song, "wb").write(song.content)
    print(f"save song '{song_name}' to {full_path_song}")

print("Success download album!")
