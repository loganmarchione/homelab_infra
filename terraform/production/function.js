function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Responses
    var response_resume = {
        statusCode: 301,
        statusDescription: "Moved Permanently",
        headers: {
            "location": { "value": "https://loganmarchione.rocks/resumes/LoganMarchione_Resume_2024-06-25.pdf" }
        }
    }

    var response_feed = {
        statusCode: 301,
        statusDescription: "Moved Permanently",
        headers: {
            "location": { "value": "/index.xml" }
        }
    }

    // Returns
    if (uri === "/resume") {
        return response_resume;
    }

    if (uri === "/feed" || uri === "/feed/") {
        return response_feed;
    }

    // https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/example-function-add-index.html
    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    }
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    // If none of the above conditions are met, return the original request
    return request;
}
