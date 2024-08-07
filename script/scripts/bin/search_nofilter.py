import webbrowser
import sys

url = "https://www.google.com/search?q="



def create_query():
    query = sys.argv[1:]
    return ' '.join(query)

def create_url():
    if len(sys.argv[1:]) == 0:
        print("Error:Please enter a valid search query")
    else:
        final_url = url + create_query() 
        webbrowser.open(final_url)


create_url()
