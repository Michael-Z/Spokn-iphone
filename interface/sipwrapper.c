/** SIP wrapper

	this module proxies the sip callbacks and apis so that they appear consistent to the
	rest of the user agent as ltp calls and callbacks.
*/

#include <ltpmobile.h>
#include <stdlib.h>
#include <string.h>
#define USERAGENT  "desktop-windows-d2-1.0"
#include <pjsua-lib/pjsua.h>

#ifdef _WIN32_WCE
#define stricmp _stricmp
#elif defined WIN32
#define stricmp _stricmp
#else
#define stricmp strcasecmp
#endif 


extern struct ltpStack *pstack;
#define THIS_FILE	"APP"
#define SIP_DOMAIN	"spokn.com"

pjsua_acc_config acccfg;

/* md5 functions :
as md5 alogrithm is sensitive big/little endian integer representation,
we have adapted the original md5 source code written by Colim Plum that
as then hacked by John Walker.
If you are studying the LTP source code, then skip this section and move onto
the queue section. */

/*typedef unsigned int32 uint32;

struct MD5Context {
		uint32 buf[4];
		uint32 bits[2];
		unsigned char in[64];
};*/

static void zeroMemory(void *p, int countBytes)
{
	char *q;

	q = (char *)p;
	while(countBytes--)
		*q++ = 0;
}

void byteReverse(unsigned char *buf, unsigned longs)
{
	uint32 t;
	do {
		t = (uint32) ((unsigned) buf[3] << 8 | buf[2]) << 16 |
			((unsigned) buf[1] << 8 | buf[0]);
		*(uint32 *) buf = t;
		buf += 4;
	} while (--longs);
}

/* The four core functions - F1 is optimized somewhat */

/* #define F1(x, y, z) (x & y | ~x & z) */
#define F1(x, y, z) (z ^ (x & (y ^ z)))
#define F2(x, y, z) F1(z, x, y)
#define F3(x, y, z) (x ^ y ^ z)
#define F4(x, y, z) (y ^ (x | ~z))

/* This is the central step in the MD5 algorithm. */
#define MD5STEP(f, w, x, y, z, data, s) \
		( w += f(x, y, z) + data,  w = w<<s | w>>(32-s),  w += x )

/*
 * The core of the MD5 algorithm, this alters an existing MD5 hash to
 * reflect the addition of 16 longwords of new data.  MD5Update blocks
 * the data and converts bytes into longwords for this routine.
 */
void MD5Transform(uint32 *buf, uint32 *in)
{
	register uint32 a, b, c, d;

	a = buf[0];
	b = buf[1];
	c = buf[2];
	d = buf[3];

	MD5STEP(F1, a, b, c, d, in[0] + 0xd76aa478, 7);
	MD5STEP(F1, d, a, b, c, in[1] + 0xe8c7b756, 12);
	MD5STEP(F1, c, d, a, b, in[2] + 0x242070db, 17);
	MD5STEP(F1, b, c, d, a, in[3] + 0xc1bdceee, 22);
	MD5STEP(F1, a, b, c, d, in[4] + 0xf57c0faf, 7);
	MD5STEP(F1, d, a, b, c, in[5] + 0x4787c62a, 12);
	MD5STEP(F1, c, d, a, b, in[6] + 0xa8304613, 17);
	MD5STEP(F1, b, c, d, a, in[7] + 0xfd469501, 22);
	MD5STEP(F1, a, b, c, d, in[8] + 0x698098d8, 7);
	MD5STEP(F1, d, a, b, c, in[9] + 0x8b44f7af, 12);
	MD5STEP(F1, c, d, a, b, in[10] + 0xffff5bb1, 17);
	MD5STEP(F1, b, c, d, a, in[11] + 0x895cd7be, 22);
	MD5STEP(F1, a, b, c, d, in[12] + 0x6b901122, 7);
	MD5STEP(F1, d, a, b, c, in[13] + 0xfd987193, 12);
	MD5STEP(F1, c, d, a, b, in[14] + 0xa679438e, 17);
	MD5STEP(F1, b, c, d, a, in[15] + 0x49b40821, 22);

	MD5STEP(F2, a, b, c, d, in[1] + 0xf61e2562, 5);
	MD5STEP(F2, d, a, b, c, in[6] + 0xc040b340, 9);
	MD5STEP(F2, c, d, a, b, in[11] + 0x265e5a51, 14);
	MD5STEP(F2, b, c, d, a, in[0] + 0xe9b6c7aa, 20);
	MD5STEP(F2, a, b, c, d, in[5] + 0xd62f105d, 5);
	MD5STEP(F2, d, a, b, c, in[10] + 0x02441453, 9);
	MD5STEP(F2, c, d, a, b, in[15] + 0xd8a1e681, 14);
	MD5STEP(F2, b, c, d, a, in[4] + 0xe7d3fbc8, 20);
	MD5STEP(F2, a, b, c, d, in[9] + 0x21e1cde6, 5);
	MD5STEP(F2, d, a, b, c, in[14] + 0xc33707d6, 9);
	MD5STEP(F2, c, d, a, b, in[3] + 0xf4d50d87, 14);
	MD5STEP(F2, b, c, d, a, in[8] + 0x455a14ed, 20);
	MD5STEP(F2, a, b, c, d, in[13] + 0xa9e3e905, 5);
	MD5STEP(F2, d, a, b, c, in[2] + 0xfcefa3f8, 9);
	MD5STEP(F2, c, d, a, b, in[7] + 0x676f02d9, 14);
	MD5STEP(F2, b, c, d, a, in[12] + 0x8d2a4c8a, 20);

	MD5STEP(F3, a, b, c, d, in[5] + 0xfffa3942, 4);
	MD5STEP(F3, d, a, b, c, in[8] + 0x8771f681, 11);
	MD5STEP(F3, c, d, a, b, in[11] + 0x6d9d6122, 16);
	MD5STEP(F3, b, c, d, a, in[14] + 0xfde5380c, 23);
	MD5STEP(F3, a, b, c, d, in[1] + 0xa4beea44, 4);
	MD5STEP(F3, d, a, b, c, in[4] + 0x4bdecfa9, 11);
	MD5STEP(F3, c, d, a, b, in[7] + 0xf6bb4b60, 16);
	MD5STEP(F3, b, c, d, a, in[10] + 0xbebfbc70, 23);
	MD5STEP(F3, a, b, c, d, in[13] + 0x289b7ec6, 4);
	MD5STEP(F3, d, a, b, c, in[0] + 0xeaa127fa, 11);
	MD5STEP(F3, c, d, a, b, in[3] + 0xd4ef3085, 16);
	MD5STEP(F3, b, c, d, a, in[6] + 0x04881d05, 23);
	MD5STEP(F3, a, b, c, d, in[9] + 0xd9d4d039, 4);
	MD5STEP(F3, d, a, b, c, in[12] + 0xe6db99e5, 11);
	MD5STEP(F3, c, d, a, b, in[15] + 0x1fa27cf8, 16);
	MD5STEP(F3, b, c, d, a, in[2] + 0xc4ac5665, 23);

	MD5STEP(F4, a, b, c, d, in[0] + 0xf4292244, 6);
	MD5STEP(F4, d, a, b, c, in[7] + 0x432aff97, 10);
	MD5STEP(F4, c, d, a, b, in[14] + 0xab9423a7, 15);
	MD5STEP(F4, b, c, d, a, in[5] + 0xfc93a039, 21);
	MD5STEP(F4, a, b, c, d, in[12] + 0x655b59c3, 6);
	MD5STEP(F4, d, a, b, c, in[3] + 0x8f0ccc92, 10);
	MD5STEP(F4, c, d, a, b, in[10] + 0xffeff47d, 15);
	MD5STEP(F4, b, c, d, a, in[1] + 0x85845dd1, 21);
	MD5STEP(F4, a, b, c, d, in[8] + 0x6fa87e4f, 6);
	MD5STEP(F4, d, a, b, c, in[15] + 0xfe2ce6e0, 10);
	MD5STEP(F4, c, d, a, b, in[6] + 0xa3014314, 15);
	MD5STEP(F4, b, c, d, a, in[13] + 0x4e0811a1, 21);
	MD5STEP(F4, a, b, c, d, in[4] + 0xf7537e82, 6);
	MD5STEP(F4, d, a, b, c, in[11] + 0xbd3af235, 10);
	MD5STEP(F4, c, d, a, b, in[2] + 0x2ad7d2bb, 15);
	MD5STEP(F4, b, c, d, a, in[9] + 0xeb86d391, 21);

	buf[0] += a;
	buf[1] += b;
	buf[2] += c;
	buf[3] += d;
}

/*
 * Start MD5 accumulation.	Set bit count to 0 and buffer to mysterious
 * initialization constants.
 */
void MD5Init(struct MD5Context *ctx)
{
	ctx->buf[0] = 0x67452301;
	ctx->buf[1] = 0xefcdab89;
	ctx->buf[2] = 0x98badcfe;
	ctx->buf[3] = 0x10325476;

	ctx->bits[0] = 0;
	ctx->bits[1] = 0;
}

/*
 * Update context to reflect the concatenation of another buffer full
 * of bytes.
 */
void MD5Update(struct MD5Context *ctx, unsigned char const  *buf, unsigned len, int isBigEndian)
{
	uint32 t;

	/* Update bitcount */

	t = ctx->bits[0];
	if ((ctx->bits[0] = t + ((uint32) len << 3)) < t)
		ctx->bits[1]++; 		/* Carry from low to high */
	ctx->bits[1] += len >> 29;

	t = (t >> 3) & 0x3f;		/* Bytes already in shsInfo->data */

	/* Handle any leading odd-sized chunks */

	if (t) {
		unsigned char *p = (unsigned char *) ctx->in + t;

		t = 64 - t;
		if (len < t) {
			memcpy(p, buf, len);
			return;
		}
		memcpy(p, buf, (size_t) t);
		if (isBigEndian)
			byteReverse(ctx->in, 16);
		MD5Transform(ctx->buf, (uint32 *) ctx->in);
		buf += t;
		len -= (int) t;
	}
	/* Process data in 64-byte chunks */

	while (len >= 64) {
		memcpy(ctx->in, buf, 64);
		if (isBigEndian)
			byteReverse(ctx->in, 16);
		MD5Transform(ctx->buf, (uint32 *) ctx->in);
		buf += 64;
		len -= 64;
	}

	/* Handle any remaining bytes of data. */

	memcpy(ctx->in, buf, len);
}

/*
 * Final wrapup - pad to 64-byte boundary with the bit pattern 
 * 1 0* (64-bit count of bits processed, MSB-first)
 */
void MD5Final(unsigned char *digest, struct MD5Context *ctx)
{
	unsigned count;
	unsigned char *p;

	/* Compute number of bytes mod 64 */
	count = (unsigned) ((ctx->bits[0] >> 3) & 0x3F);

	/* Set the first char of padding to 0x80.  This is safe since there is
	   always at least one byte free */
	p = ctx->in + count;
	*p++ = 0x80;

	/* Bytes of padding needed to make 64 bytes */
	count = 64 - 1 - count;

	/* Pad out to 56 mod 64 */
	if (count < 8) {
		/* Two lots of padding:  Pad the first block to 64 bytes */
		memset(p, 0, count);
		byteReverse(ctx->in, 16);
		MD5Transform(ctx->buf, (uint32 *) ctx->in);

		/* Now fill the next block with 56 bytes */
		memset(ctx->in, 0, 56);
	} else {
		/* Pad block to 56 bytes */
		memset(p, 0, count - 8);
	}
	byteReverse(ctx->in, 14);

	/* Append length in bits and transform */
	((uint32 *) ctx->in)[14] = ctx->bits[0];
	((uint32 *) ctx->in)[15] = ctx->bits[1];

	MD5Transform(ctx->buf, (uint32 *) ctx->in);
	byteReverse((unsigned char *) ctx->buf, 4);
	memcpy(digest, ctx->buf, 16);
    memset(ctx, 0, sizeof(ctx));        /* In case it's sensitive */
}


/* a hash function to compute chat string hashes */
static unsigned long hash(void *data, int length){
	unsigned long hash = 5381;
    int c;
	unsigned char *str = (unsigned char *)data;

    while (length--)
	{
		c = *str++;
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
	}
    return hash;
}

/* queue functions:
we use these queues for piping pcm samples.

You basically init the queue, enque samples and then read them back
with deque. Quite handy in other places too.
  
I suspect that these queues are thread-safe.
The reason is that the enque deque functions dont access
the same variables. so as long as you read from one thread
and write in another all the time, you are fine. 

There are a couple of interesting, non-standard behaviours in this queue.
First, these never block. second, dequeing from an empty queue will
return '0'samples.

*/


void queueInit(struct Queue *p)
{
	p->head = 0;
	p->tail = 0;
	p->count = 0;
	p->stall = 1;
}

void queueEnque(struct Queue *p, short16 w)
{
	if (p->count == MAX_Q)
		return;

	p->data[p->head++] = w;
	p->count++;
	if (p->head == MAX_Q)
		p->head = 0;
	if (p->count > 1600 && p->stall == 1)
	{
		p->stall = 0;
	}
}

short16 queueDeque(struct Queue *p)
{
	short data;

	if (!p->count || p->stall)
		return 0;

	data = p->data[p->tail++];
	p->count--;
	if (p->tail == MAX_Q)
		p->tail = 0;
	return data;
}


/*  
callFindIdle:
finds an empty slot to start a new call
returns NULL if not found (quite possible), always check for null */
static struct Call *callFindIdle(struct ltpStack *ps)
{
	int     i;
	struct Call *p;

	for (i = 0; i < ps->maxSlots; i++)
	{
		p = ps->call + i;
		if(p->ltpState == CALL_IDLE) 
		{
			p->remoteUserid[0] = 0;
			p->ltpState = 0;
			p->timeStart = p->timeStop = 0;
			p->kindOfCall = 0;
			return p;
		}
	}

	return NULL;
}


/* pj sip routines */

/* Callback called by the library upon receiving incoming call */
static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id,
			     pjsip_rx_data *rdata)
{
	struct pjsua_call_info ci;
	struct Call *pc = NULL;
	char *p;
	int i;

    PJ_UNUSED_ARG(acc_id);
    PJ_UNUSED_ARG(rdata);

    pjsua_call_get_info(call_id, &ci);

	//return the call if it too many calls
	pc = callFindIdle(pstack);
	if (!pc){
		pjsua_call_hangup(call_id, 0, NULL, NULL);
		return;
	}

	pc->kindOfCall = CALLTYPE_IN | CALLTYPE_CALL;	
	pc->timeStart = pstack->now;

	//example of what is in c.remote_info.ptr "+919849026029" <sip:+919849026029@spokn.com>
	//skip ahead of sip and '+' sign if any
	p = ci.remote_info.ptr;
	p = strstr(p, "sip:");
	if (p)
		p+= 4;

	if (*p == '+')
		p++;
	//copy until the end of string or '@' sign
	for (i = 0; i < MAX_USERID-1; i++){
		if (!*p || *p == '@')
			break;
		else
			pc->remoteUserid[i] = *p++;
	}
	pc->remoteUserid[i] = 0; //close the string
	pc->ltpState = CALL_RING_RECEIVED;
	pc->ltpSession = call_id; //bug#26252 - Set the call_id.
	alert(pc->lineId, ALERT_INCOMING_CALL, "");
}

/* Callback called by the library when call's state has changed */
static void on_call_state(pjsua_call_id call_id, pjsip_event *e)
{
	int	i;
	struct pjsua_call_info ci;

    pjsua_call_get_info(call_id, &ci);
	for (i = 0; i < pstack->maxSlots; i++)
		if (pstack->call[i].ltpSession == (unsigned int)call_id && pstack->call[i].ltpState != CALL_IDLE){
			switch(ci.state){
			case PJSIP_INV_STATE_CALLING:	    /**< After INVITE is sent		    */
				pstack->call[i].ltpState = CALL_RING_SENT;
				break;
			case PJSIP_INV_STATE_INCOMING:	    /**< After INVITE is received.	    */
				alert(pstack->call[i].lineId, ALERT_INCOMING_CALL, "");
				pstack->call[i].ltpState = CALL_RING_RECEIVED;
				break;
			case PJSIP_INV_STATE_EARLY:	    /**< After response with To tag.	    */				
			case PJSIP_INV_STATE_CONNECTING:	    /**< After 2xx is sent/received.	    */
				pstack->call[i].ltpState = CALL_RING_ACCEPTED;
				break;
			case PJSIP_INV_STATE_CONFIRMED:	    /**< After ACK is sent/received.	    */
				pstack->call[i].ltpState = CALL_CONNECTED;
				pstack->call[i].timeStart = pstack->now; /* reset the call timer for the correct duration */
				break;
			case PJSIP_INV_STATE_DISCONNECTED:   /**< Session is terminated.		    */
				pstack->call[i].ltpState = CALL_IDLE;
				pstack->call[i].timeStop = pstack->now;
				alert(pstack->call[i].lineId, ALERT_DISCONNECTED, "");
				break;
//			case PJSIP_INV_STATE_NULL:
//			default:
			}

			return;
		}
}

static void joinLine(int aline, int bline, int doit)
{
	int i;
	struct pjsua_call_info ca, cb;
	pjsua_call_id call_a=-1, call_b=-1;

	if (aline == bline)
		return;

	for (i = 0; i < pstack->maxSlots; i++)
		if (aline == pstack->call[i].lineId && pstack->call[i].ltpState != CALL_IDLE)
			call_a = pstack->call[i].ltpSession;


	for (i = 0; i < pstack->maxSlots; i++)
		if (bline == pstack->call[i].lineId && pstack->call[i].ltpState != CALL_IDLE)
			call_b = pstack->call[i].ltpSession;

	if (call_a == -1 || call_b == -1)
		return;

	pjsua_call_get_info(call_a, &ca);
	pjsua_call_get_info(call_b, &cb);

	if (doit){
		pjsua_conf_connect(ca.conf_slot, cb.conf_slot);
		pjsua_conf_connect(cb.conf_slot, ca.conf_slot);
	}
	else {
		pjsua_conf_disconnect(ca.conf_slot, cb.conf_slot);
		pjsua_conf_disconnect(cb.conf_slot, ca.conf_slot);
	}
}

static void connectLineToSoundCard(int aline, int doit)
{
	int i;
	struct pjsua_call_info ca;
	pjsua_call_id call_a=-1;

	if (aline == -1)
		return;

	for (i = 0; i < pstack->maxSlots; i++)
		if (aline == pstack->call[i].lineId && pstack->call[i].ltpState != CALL_IDLE)
			call_a = pstack->call[i].ltpSession;

	if (call_a == -1)
		return;

	pjsua_call_get_info(call_a, &ca);

	if (doit){
		pjsua_conf_connect(ca.conf_slot, 0);
		pjsua_conf_connect(0, ca.conf_slot);
	}
	else {
		pjsua_conf_disconnect(ca.conf_slot, 0);
		pjsua_conf_disconnect(0, ca.conf_slot);
	}			
}

static void joinCalls()
{
	int i, j;

	for (i = 0; i < pstack->maxSlots; i++){
		if (pstack->call[i].ltpState != CALL_CONNECTED || !pstack->call[i].InConference)
			continue;

		for (j = 0; j < pstack->maxSlots; j++)
			if (j==i || pstack->call[j].ltpState != CALL_CONNECTED || !pstack->call[j].InConference)
				continue;
			else
				joinLine(pstack->call[i].lineId, pstack->call[j].lineId, 1);
	}
}

/* Callback called by the library when call's media state has changed */
static void on_call_media_state(pjsua_call_id call_id)
{
	int	 i, j;
	struct Call *pc;
	struct pjsua_call_info ci;

    pjsua_call_get_info(call_id, &ci);

    if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
		// When media is active, connect call to sound device.
		pjsua_conf_connect(ci.conf_slot, 0);
		pjsua_conf_connect(0, ci.conf_slot);
		printf ("FARHAN: connected  %d to the sound card.\n", ci.conf_slot);
    }

	//update the call status
	for (i = 0; i < pstack->maxSlots; i++){
		pc = pstack->call + i;
		if (pc->ltpSession == call_id){
			if (ci.media_status == PJSUA_CALL_MEDIA_LOCAL_HOLD)
				pc->remoteVoice = 0;
			if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
				pc->remoteVoice = 1;
				
				if (pc->InConference)
					joinCalls();
				else 
				{ //handle the non-conference call
					for (j = 0; j < pstack->maxSlots; j++){
						if (pstack->call[j].ltpSession != pc->ltpSession &&
							pstack->call[j].ltpState == CALL_CONNECTED)
						{
							pjsua_call_id other_call = (pjsua_call_id)pstack->call[j].ltpSession;
							pjsua_call_get_info(other_call, &ci);
							pjsua_conf_disconnect(ci.conf_slot, 0);
							pjsua_conf_disconnect(0, ci.conf_slot);
							printf ("FARHAN: disconnected  %d to the sound card.\n", ci.conf_slot);
						}
					}
				} // end of handling non-conference call

			}
			alert(pstack->call[i].lineId, ALERT_CONNECTED, NULL);
		}
	}
}

static void on_reg_state(pjsua_acc_id acc_id)
{
	char	buff[100];
	pjsua_acc_info	info;
	pj_status_t status;

	if (!pstack)
		return;

	status = pjsua_acc_get_info(acc_id, &info);

	if (info.status == 0){
		pstack->loginStatus = LOGIN_STATUS_OFFLINE;
		alert(-1, ALERT_OFFLINE, info.status_text.ptr);
	}
	else if (info.status >= 100 && 200 > info.status)
		pstack->loginStatus = LOGIN_STATUS_TRYING_LOGIN;
	else if (info.status == 200){
		if (info.expires > 0){
			pstack->loginStatus = LOGIN_STATUS_ONLINE;
			alert(-1, ALERT_ONLINE, info.status_text.ptr);
		}
		else {
			pstack->loginStatus = LOGIN_STATUS_OFFLINE;
			alert(-1, ALERT_OFFLINE, info.status_text.ptr);
		}
	}
	else if (info.status == 401 || info.status == 407)
		pstack->loginStatus = LOGIN_STATUS_TRYING_LOGIN;
		
	else if ((info.status >= 400 && info.status < 500 && (info.status != 401 ||info.status != 407)) || 
			 (info.status >= PJSIP_EFAILEDCREDENTIAL && info.status <= PJSIP_EAUTHSTALECOUNT))
	{
		pstack->loginStatus = LOGIN_STATUS_FAILED;
		alert(-1, ALERT_OFFLINE, info.status_text.ptr);
	}
	else if (info.status >= 500)
		pstack->loginStatus = LOGIN_STATUS_NO_ACCESS;
	
	sprintf(buff, "%d", info.status);
//	SetDlgItemTextA(wndMain, IDC_STATUS, buff);
}


static int spokn_pj_init(char *errorstring)
{
	pjsua_config cfg;
	pjsua_logging_config log_cfg;
	pj_status_t status;
	pjsua_transport_config transcfg;
	pjsua_media_config cfgmedia;
	printf("\n pj init");
    /* Create pjsua first! */
    status = pjsua_create();

	if (status != PJ_SUCCESS){
		strcpy(errorstring, "Error in pjsua_create()");
		return 0;
	}

	/* Init pjsua */

	pjsua_config_default(&cfg);
	cfg.cb.on_incoming_call = &on_incoming_call;
	cfg.cb.on_call_media_state = &on_call_media_state;
	cfg.cb.on_call_state = &on_call_state;
	cfg.cb.on_reg_state = &on_reg_state;

	pjsua_logging_config_default(&log_cfg);
	log_cfg.console_level = 0;
	 pjsua_media_config_default(&cfgmedia);
	cfgmedia.clock_rate = 8000;
	cfgmedia.snd_clock_rate = 8000;
	//app_config->media_cfg.clock_rate = 44100;
	//app_config->media_cfg.snd_clock_rate = 44100;
	//app_config->media_cfg.ec_options = 0;//0=default,1=speex, 2=suppressor
	
	//cfgmedia.ec_tail_len = 0;
	
	// Enable/Disable VAD/silence detector
	//cfgmedia.no_vad = NO;
	
	cfgmedia.snd_auto_close_time = 0;
	//app_config->media_cfg.quality = 2;
	//app_config->media_cfg.channel_count = 2;
	
	
	
	
	
	status = pjsua_init(&cfg, &log_cfg, &cfgmedia);
	if (status != PJ_SUCCESS){
		strcpy(errorstring, "Error in pjsua_init()");
		return 0;
	}

    /* Add UDP transport. */

	pjsua_transport_config_default(&transcfg);
	transcfg.port = 5060;
	status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &transcfg, NULL);
	if (status != PJ_SUCCESS){
		strcpy(errorstring, "Error creating transport");
		return 0;
    }

    /* Initialization is done, now start pjsua */
    status = pjsua_start();
	if (status != PJ_SUCCESS){ 
		strcpy(errorstring, "Error starting pjsua");
		return 0;
	}

    pjsua_detect_nat_type();
	return 1;
}

/* 
ltpInit:
this is the big one. It calls malloc (from standard c library). If your system doesn't support
dynamic memory, no worry, just pass a pointer to a preallocated block of the size of ltpStack. It is
a one time allocation. The call structures inside are also allocated just once in the entire stack's
lifecycle. The memory is nevery dynamically allocated during the runtime.

We could have declared ltpStack and Calls as global data, however a number of systems do not allow
global writeable data (like the Symbian) hence, we request for memory. Most systems can simply return 
a pointer to preallocated memory */

struct ltpStack  *ltpInit(int maxslots, int maxbitrate, int framesPerPacket)
{
	int	i;
	struct Call *p;
	struct ltpStack *ps;
	char	errorstr[100];

	ps = (struct ltpStack *)malloc(sizeof(struct ltpStack));
	if (!ps)
		return NULL;

	zeroMemory(ps, sizeof(struct ltpStack));	

	ps->defaultCodec = (short16) maxbitrate;
	ps->loginCommand = CMD_LOGIN;
	ps->loginStatus = LOGIN_STATUS_OFFLINE;
	ps->ringTimeout  = 30;
	ps->myPriority = NORMAL_PRIORITY;
	strncpy(ps->userAgent,USERAGENT, MAX_USERID);
	ps->ltpPresence = NOTIFY_ONLINE;
	ps->updateTimingAdvance = 0;

	ps->maxSlots = maxslots;
	ps->call = (struct Call *) malloc(sizeof(struct Call) * maxslots);
	if (!ps->call)
		return NULL;
	zeroMemory(ps->call, sizeof(struct Call) * maxslots);	

	ps->chat = (struct Message *) malloc(sizeof(struct Call) * MAX_CHATS);
	if (!ps->chat)
		return NULL;
	zeroMemory(ps->chat, sizeof(struct Message) * MAX_CHATS);
	ps->maxMessageRetries = 3;

	for (i=0; i<maxslots; i++)
	{
		p = ps->call + i;
		/* assign lineId */
		p->lineId = i;
		p->ltpState = CALL_IDLE;
	}


	/* determine if we are on a big-endian architecture */
	i = 1;
	if (*((char *)&i))
		ps->bigEndian = 0;
	else
		ps->bigEndian = 1;

	if (!spokn_pj_init(errorstr)){
		printf ("PJ not initiallized: %s\n");
		free(ps);
		return NULL;
	}
	return ps;
}


/**
	pj sip wrappers
*/



void ltpTick(struct ltpStack *ps, unsigned int timeNow)
{
	pstack->now = timeNow;
	pjsua_handle_events(1);
}


/* these functions have to be wrapped around the pjsip stack */

void ltpMessageDTMF(struct ltpStack *ps, int lineid, char *msg)
{
	pj_str_t digits;

	digits = pj_str(msg);
	if (ps->call[lineid].ltpState != CALL_IDLE)
		pjsua_call_dial_dtmf((pjsua_call_id)ps->call[lineid].ltpSession, &digits);
}


void ltpLogin(struct ltpStack *ps, int command)
{
	pjsua_acc_id acc_id;
	char	url[128];
    /* Register to SIP server by creating SIP account. */

	if (command == CMD_LOGIN){
		
		//check if an account already exists
		if (strlen(pstack->ltpUserid) && strlen(pstack->ltpPassword) && pjsua_acc_get_count() > 0){
			acc_id = pjsua_acc_get_default();
			if (acc_id != PJSUA_INVALID_ID){

				//if the the account details are the same, then just re-register
				if (!strcmp(pstack->ltpUserid, acccfg.cred_info[0].username.ptr) &&
					!strcmp(pstack->ltpPassword, acccfg.cred_info[0].data.ptr))
				{
					pjsua_acc_set_registration(acc_id, PJ_TRUE);
					return;
				}
			}

			//account details don't match, then delete this account and create a new default account
			pjsua_acc_del(acc_id);
		}

		pjsua_acc_config_default(&acccfg);

		sprintf(url, "sip:%s@%s", pstack->ltpUserid, SIP_DOMAIN);
		acccfg.id = pj_str(url);
		acccfg.reg_uri = pj_str("sip:" SIP_DOMAIN);
		acccfg.cred_count = 1;
		acccfg.cred_info[0].realm = pj_str(SIP_DOMAIN);
		acccfg.cred_info[0].scheme = pj_str("digest");
		acccfg.cred_info[0].username = pj_str(pstack->ltpUserid);
		acccfg.cred_info[0].data_type = PJSIP_CRED_DATA_PLAIN_PASSWD;
		acccfg.cred_info[0].data = pj_str(pstack->ltpPassword);

		pjsua_acc_add(&acccfg, PJ_TRUE, &acc_id);
	}

	if (command == CMD_LOGOUT) {
		acc_id = pjsua_acc_get_default();

		if (acc_id != PJSUA_INVALID_ID)
			pjsua_acc_set_registration(acc_id, PJ_FALSE);
	}
}

/* at the moment this simply unregisters from the sip server, maybe something else is required here */
void ltpLoginCancel(struct ltpStack *ps)
{
	pjsua_acc_id acc_id = pjsua_acc_get_default();

	if (acc_id != PJSUA_INVALID_ID)
		pjsua_acc_del(acc_id);
}

/* we reuse the ltpSession member of the call slot to hold the callid of pjsip in the ltpstack 
*/

void ltpHangup(struct ltpStack *ps, int lineid)
{
	int	i;
	pjsua_call_id call_id;

	for (i = 0; i < ps->maxSlots; i++)
	{
		if (ps->call[i].lineId == lineid && ps->call[i].ltpState != CALL_IDLE){
			call_id = (pjsua_call_id) ps->call[i].ltpSession;
			printf("ltpHangup: lineid: %d\t call_id: %d\t ltpstate: %d\n", ps->call[i].lineId, call_id, ps->call[i].ltpState);
			if (ps->call[i].ltpState != CALL_CONNECTED)
				ps->call[i].kindOfCall |= CALLTYPE_MISSED;
			//bug#26268, the incoming call has been rejected
			if (ps->call[i].ltpState == CALL_RING_RECEIVED)
			{
				pj_str_t pjStr;  
				pjStr.ptr = "Busy Here"; 
				pjStr.slen =  strlen(pjStr.ptr);
				ps->call[i].ltpState = CALL_HANGING;
				pjsua_call_answer(call_id, PJSIP_SC_BUSY_HERE, &pjStr, NULL);
			}
			//else this is a regular hangup
			else
			{
				ps->call[i].ltpState = CALL_HANGING;
				pjsua_call_hangup(call_id, 0, NULL, NULL);
			}
			return;
		}
	}
}

int ltpRing(struct ltpStack *ps, char *remoteid, int command)
{
	int i;
	char	struri[128];
	pj_str_t uri;
	struct Call *pc;
	pjsua_call_id call_id;

	pc = callFindIdle(pstack);
	if (!pc){
		alert(-1, ALERT_ERROR, "Too many calls");
		return 0;
	}

	if (strncmp(remoteid, "sip:", 4))
		sprintf(struri, "sip:+%s@spokn.com", remoteid);
	else
		strcpy(struri, remoteid);

	uri = pj_str(struri);
	if (pjsua_call_make_call(pjsua_acc_get_default(), &uri, 0, NULL, NULL, &call_id) == PJ_SUCCESS){
		strcpy(pc->remoteUserid, remoteid);
		pc->ltpSession = (unsigned int) call_id;
		pc->ltpState = CALL_RING_SENT;
	}

	pc->kindOfCall = CALLTYPE_OUT | CALLTYPE_CALL;
	pc->timeStart = pstack->now;
	ps->activeLine =pc->lineId;

	//put all the other calls on hold
	for (i = 0; i < ps->maxSlots; i++)
		if (ps->call[i].lineId != pc->lineId && ps->call[i].ltpState != CALL_IDLE && !ps->call[i].InConference)
			pjsua_call_set_hold((pjsua_call_id)ps->call[i].ltpSession, NULL);

	return pc->lineId;
}

void ltpAnswer(struct ltpStack *ps, int lineid)
{
	int	i;
	pjsua_call_id call_id;

	for (i = 0; i < ps->maxSlots; i++)
		if (ps->call[i].lineId == lineid && ps->call[i].ltpState != CALL_IDLE){
			call_id = (pjsua_call_id) ps->call[i].ltpSession;
			pjsua_call_answer(call_id, 200, NULL, NULL);
			ps->activeLine = lineid;
		}
}

void sipSwitchReinvite(struct ltpStack *ps, int lineid)
{
	int	i, inConf=0;
	pjsua_call_id call_id;

	for (i = 0; i < ps->maxSlots; i++)
		if (lineid == ps->call[i].lineId && ps->call[i].ltpState == CALL_CONNECTED && ps->call[i].InConference)
			inConf = 1;

	for (i = 0; i < ps->maxSlots; i++)
		if (ps->call[i].ltpState != CALL_IDLE){
			call_id = (pjsua_call_id) ps->call[i].ltpSession;
			if (lineid == ps->call[i].lineId){
				pjsua_call_reinvite((pjsua_call_id)ps->call[i].ltpSession, PJ_TRUE, NULL);
				ps->activeLine = lineid;
			}
			else if (!ps->call[i].InConference && ps->call[i].ltpState == CALL_CONNECTED) //hold all the calls not in conference
				pjsua_call_set_hold((pjsua_call_id)ps->call[i].ltpSession, NULL);
		}
}

void startConference ()
{
	int	i, inConf=0;

	for (i = 0; i < pstack->maxSlots; i++)
		if (pstack->call[i].ltpState != CALL_IDLE){
			pjsua_call_reinvite((pjsua_call_id)pstack->call[i].ltpSession, PJ_TRUE, NULL);
			pstack->call[i].InConference = 1;
		}
}