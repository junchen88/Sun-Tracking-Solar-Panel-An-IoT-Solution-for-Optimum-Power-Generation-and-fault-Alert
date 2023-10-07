% This script obtains the gps data from channel and updates the channel's setting
% location data.

% Set 'readChannelID' to the channel ID of the channel to read from. Since 
% this is a private channel, also assign the read API Key to the 'readAPIKey'
% variable. You can find the read API Key on the right side pane of this page.


% TODO - Replace the [] with your own values:
readChannelID = [];
readAPIKey = [];

userAPIKey = [];

%% Read and Analyze Data %%
data = thingSpeakRead(readChannelID, 'ReadKey', readAPIKey, 'numpoints',1, Location=1, OutputFormat='TimeTable');
latitude = data.Latitude;
longitude = data.Longitude;
elevation = data.Altitude;

% Define the URL for the ThingSpeak channel update API 
url = 'https://api.thingspeak.com/channels/'+string(readChannelID)+'.json';  
% Define the data to be sent in the body of the PUT request 
upload_data = struct('api_key', userAPIKey, 'latitude', latitude, 'longitude', longitude, 'elevation', elevation);
% Send the PUT request
response = webwrite(url, upload_data, weboptions('RequestMethod', 'put'));
disp(response)


