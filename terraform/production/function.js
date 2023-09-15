function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Rewrite URL
    if (uri === "/resume") {
        var response = {
            statusCode: 301,
            statusDescription: "Moved Permanently",
            headers: {
                "location": { "value": "https://loganmarchione.rocks/resumes/LoganMarchione_Resume_2023-03-31.pdf" }
            }
        }
        return response;
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
