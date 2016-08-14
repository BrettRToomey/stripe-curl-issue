import CCurl

final class WriteData {
	var data = [CChar]()
	init(){}
}

/* libcurl init (once per app) */
let status = curl_global_init(Int(CURL_GLOBAL_SSL))
print(status == CURLE_OK)

/* curl handle init (one per request) */
let handle = curl_easy_init()

/* set url */
curlHelperSetOptString(handle, CURLOPT_URL, "https://api.stripe.com/v1/customers")

/* stripe requires an API token, so we provide it with their test token*/
curlHelperSetOptString(handle, CURLOPT_USERNAME, "sk_test_BQokikJOvBiI2HlWgH4olfQ2")

/* set method to POST. This is done by default if you set postfields, but */
/* I'm doing this just to make sure the problem isn't me */
curlHelperSetOptBool(handle, CURLOPT_POST, CURL_TRUE)

/* set the fields as a string so we can later calculate their size */
let postfields = "description=hey&email=test@test.me"
/* set post fields*/
curlHelperSetOptString(handle, CURLOPT_POSTFIELDS, postfields)
/* set the size of the postfields. cURL clib will automatically `strln` */
/* postfields if you don't set a size, but we're doing this to be sure */
curlHelperSetOptInt(handle, CURLOPT_POSTFIELDSIZE, postfields.characters.count)

/* instance of storage for write callback */
var data = WriteData()
curlHelperSetOptWriteFunc(handle, &data) { ptr, size, nmemb, userdata in
	/* print response from server */
	print(String(cString: ptr!))
	return size * nmemb
}
/* run */
let result = curl_easy_perform(handle)
print(result == CURLE_OK)

/* cleanup */
curl_easy_cleanup(handle)
curl_global_cleanup()
