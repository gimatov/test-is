let ariClient = require('ari-client');
let redis = require('redis');

let ariConnction;
const db = redis.createClient({
	url: process.env.REDIS_URL,
	password: process.env.REDIS_PASSWORD
})

async function init() {
	await db.connect()
	await db.sAdd('sounds', ['astcc-followed-by-the-pound-key', 'sorry', 'call-fwd-unconditional']);

	ariConnction = await ariClient.connect(process.env.ARI_URL, process.env.ARI_USER, process.env.ARI_PASSWORD)
	ariConnction.on('StasisStart', stasisStart);
	ariConnction.start('is-test');
}

async function stasisStart(event, incoming) {
	const sound = await db.sPop('sounds');
	if (sound) {
		await ariConnction.channels.setChannelVar({
			channelId: incoming.id,
			variable: 'variablename',
			value: sound
		})
	}
	await ariConnction.channels.continueInDialplan({
		channelId: incoming.id
	})
}

init().catch(console.error);