string discordWebhookURL = "DISCORD URL";

// --- SCRIPT LOGIC (No need to edit below this line) ---

// Global variables to track the last message for de-duplication purposes.
string g_lastMessage;
key    g_lastSpeakerID;
float  g_lastMessageTime;

default
{
    /**
     * @brief This event runs once when the script starts or is reset.
     */
    state_entry()
    {
        // This is a safety check to ensure the URL is not empty.
        if (discordWebhookURL == "")
        {
            llOwnerSay("ERROR: The 'discordWebhookURL' is empty. Please edit the script to add your webhook URL.");
            return; // Stop the script if the URL is not set.
        }
        
        // Start listening on channel 0 for any message from any avatar.
        llListen(0, "", NULL_KEY, "");
        llOwnerSay("LSL to Discord Relay: Initialized. Listening for messages on channel 0.");
    }

    listen(integer channel, string name, key id, string message)
    {
        if (id == g_lastSpeakerID && message == g_lastMessage && (llGetTime() - g_lastMessageTime < 2.0))
        {
            return; // It's a duplicate, so we stop processing it.
        }

        g_lastSpeakerID = id;
        g_lastMessage = message;
        g_lastMessageTime = llGetTime();
        
        if (llGetAgentSize(id) != ZERO_VECTOR)
        {
            string utcTimestamp = llGetTimestamp(); 

            // Parse the timestamp string into its components
            list parts = llParseString2List(utcTimestamp, ["-", "T", ":", "."], []);
            string year = llList2String(parts, 0);
            string month = llList2String(parts, 1);
            string day = llList2String(parts, 2);
            string hour = llList2String(parts, 3);
            string minute = llList2String(parts, 4);
            string second = llList2String(parts, 5);

            // Assemble the timestamp in the desired format: (MM-DD-YYYY-H-M-seconds)
            string formattedTimestamp = "(" + month + "-" + day + "-" + year + "-" + hour + "-" + minute + "-" + second + ")";
            
            // Format the final message with the timestamp, name, and the original message.
            string formattedMessage = formattedTimestamp + " " + name + ": " + message;
            
            // Create a valid JSON payload that Discord's API expects.
            string jsonPayload = llJsonSetValue("{'content':''}", ["content"], formattedMessage);

            // Send the data to the Discord webhook via an HTTP POST request.
            llHTTPRequest(discordWebhookURL, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/json"], jsonPayload);
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
}

