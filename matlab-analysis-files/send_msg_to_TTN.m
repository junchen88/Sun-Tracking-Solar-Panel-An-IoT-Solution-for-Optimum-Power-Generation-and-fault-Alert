% Triggers this function when the reset button is pressed on the user interface.

% TODO - Replace the [] with your own values - safety reason
readChannelID = [];
readAPIKey = [];

%% Read and Analyze Data %%
data = thingSpeakRead(readChannelID, 'ReadKey', readAPIKey, 'numpoints',1, Location=1, OutputFormat='TimeTable');
resetValue = data.Reset;
if resetValue == 123
    
    % define the parameters for the HTTP request to TTN
    writeAPIKey = [];
    headerAPI = 'Bearer '+writeAPIKey;
    appID = 'solar-sun-tracker';
    deviceID = 'eui-70b3d57ed006110f';
    base64Message = "ABg="; %command for reset - 0x18
    
    % Define the URL
    url = ['https://au1.cloud.thethings.network/api/v3/as/applications/',appID,'/devices/',deviceID,'/down/replace'];
    
    % Define the headers
    options = weboptions('RequestMethod', 'post', 'HeaderFields', ...
        {'Authorization' headerAPI; ...
         'Content-Type' 'application/json'; ...
         'User-Agent' 'au1.cloud.thethings.network/v3'});
    
    % Define the body
    data = struct;
    
    % Add fields to the structure - uses port 15 - must match with the one in our device
    data.downlinks = {struct('frm_payload', base64Message, 'f_port', 15, 'priority', 'NORMAL')};
    % Send the request
    response = webwrite(url, data, options);
    
    % Display the response
    disp(response)
end