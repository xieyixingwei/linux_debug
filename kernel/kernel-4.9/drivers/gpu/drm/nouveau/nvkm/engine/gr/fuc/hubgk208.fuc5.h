uint32_t gk208_grhub_data[] = {
/* 0x0000: hub_mmio_list_head */
	0x00000300,
/* 0x0004: hub_mmio_list_tail */
	0x00000304,
/* 0x0008: gpc_count */
	0x00000000,
/* 0x000c: rop_count */
	0x00000000,
/* 0x0010: cmd_queue */
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
/* 0x0058: ctx_current */
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
/* 0x0100: chan_data */
/* 0x0100: chan_mmio_count */
	0x00000000,
/* 0x0104: chan_mmio_address */
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
/* 0x0200: xfer_data */
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
/* 0x0300: hub_mmio_list_base */
	0x0417e91c,
};

uint32_t gk208_grhub_code[] = {
	0x030e0ef5,
/* 0x0004: queue_put */
	0x9800d898,
	0x86f001d9,
	0xf489a408,
	0x020f0b1b,
	0x0002f87e,
/* 0x001a: queue_put_next */
	0x98c400f8,
	0x0384b607,
	0xb6008dbb,
	0x8eb50880,
	0x018fb500,
	0xf00190b6,
	0xd9b50f94,
/* 0x0037: queue_get */
	0xf400f801,
	0xd8980131,
	0x01d99800,
	0x0bf489a4,
	0x0789c421,
	0xbb0394b6,
	0x90b6009d,
	0x009e9808,
	0xb6019f98,
	0x84f00180,
	0x00d8b50f,
/* 0x0063: queue_get_done */
	0xf80132f4,
/* 0x0065: nv_rd32 */
	0xf0ecb200,
	0x00801fc9,
	0x0cf601ca,
/* 0x0073: nv_rd32_wait */
	0x8c04bd00,
	0xcf01ca00,
	0xccc800cc,
	0xf61bf41f,
	0xec7e060a,
	0x008f0000,
	0xffcf01cb,
/* 0x008f: nv_wr32 */
	0x8000f800,
	0xf601cc00,
	0x04bd000f,
	0xc9f0ecb2,
	0x1ec9f01f,
	0x01ca0080,
	0xbd000cf6,
/* 0x00a9: nv_wr32_wait */
	0xca008c04,
	0x00cccf01,
	0xf41fccc8,
	0x00f8f61b,
/* 0x00b8: wait_donez */
	0x99f094bd,
	0x37008000,
	0x0009f602,
	0x008004bd,
	0x0af60206,
/* 0x00cf: wait_donez_ne */
	0x8804bd00,
	0xcf010000,
	0x8aff0088,
	0xf61bf488,
	0x99f094bd,
	0x17008000,
	0x0009f602,
	0x00f804bd,
/* 0x00ec: wait_doneo */
	0x99f094bd,
	0x37008000,
	0x0009f602,
	0x008004bd,
	0x0af60206,
/* 0x0103: wait_doneo_e */
	0x8804bd00,
	0xcf010000,
	0x8aff0088,
	0xf60bf488,
	0x99f094bd,
	0x17008000,
	0x0009f602,
	0x00f804bd,
/* 0x0120: mmctx_size */
/* 0x0122: nv_mmctx_size_loop */
	0xe89894bd,
	0x1a85b600,
	0xb60180b6,
	0x98bb0284,
	0x04e0b600,
	0x1bf4efa4,
	0xf89fb2ec,
/* 0x013d: mmctx_xfer */
	0xf094bd00,
	0x00800199,
	0x09f60237,
	0xbd04bd00,
	0x05bbfd94,
	0x800f0bf4,
	0xf601c400,
	0x04bd000b,
/* 0x015f: mmctx_base_disabled */
	0xfd0099f0,
	0x0bf405ee,
	0xc6008018,
	0x000ef601,
	0x008004bd,
	0x0ff601c7,
	0xf004bd00,
/* 0x017a: mmctx_multi_disabled */
	0xabc80199,
	0x10b4b600,
	0xc80cb9f0,
	0xe4b601ae,
	0x05befd11,
	0x01c50080,
	0xbd000bf6,
/* 0x0195: mmctx_exec_loop */
/* 0x0195: mmctx_wait_free */
	0xc5008e04,
	0x00eecf01,
	0xf41fe4f0,
	0xce98f60b,
	0x05e9fd00,
	0x01c80080,
	0xbd000ef6,
	0x04c0b604,
	0x1bf4cda4,
	0x02abc8df,
/* 0x01bf: mmctx_fini_wait */
	0x8b1c1bf4,
	0xcf01c500,
	0xb4f000bb,
	0x10b4b01f,
	0x0af31bf4,
	0x00b87e05,
	0x250ef400,
/* 0x01d8: mmctx_stop */
	0xb600abc8,
	0xb9f010b4,
	0x12b9f00c,
	0x01c50080,
	0xbd000bf6,
/* 0x01ed: mmctx_stop_wait */
	0xc5008b04,
	0x00bbcf01,
	0xf412bbc8,
/* 0x01fa: mmctx_done */
	0x94bdf61b,
	0x800199f0,
	0xf6021700,
	0x04bd0009,
/* 0x020a: strand_wait */
	0xa0f900f8,
	0xb87e020a,
	0xa0fc0000,
/* 0x0216: strand_pre */
	0x0c0900f8,
	0x024afc80,
	0xbd0009f6,
	0x020a7e04,
/* 0x0227: strand_post */
	0x0900f800,
	0x4afc800d,
	0x0009f602,
	0x0a7e04bd,
	0x00f80002,
/* 0x0238: strand_set */
	0xfc800f0c,
	0x0cf6024f,
	0x0c04bd00,
	0x4afc800b,
	0x000cf602,
	0xfc8004bd,
	0x0ef6024f,
	0x0c04bd00,
	0x4afc800a,
	0x000cf602,
	0x0a7e04bd,
	0x00f80002,
/* 0x0268: strand_ctx_init */
	0x99f094bd,
	0x37008003,
	0x0009f602,
	0x167e04bd,
	0x030e0002,
	0x0002387e,
	0xfc80c4bd,
	0x0cf60247,
	0x0c04bd00,
	0x4afc8001,
	0x000cf602,
	0x0a7e04bd,
	0x0c920002,
	0x46fc8001,
	0x000cf602,
	0x020c04bd,
	0x024afc80,
	0xbd000cf6,
	0x020a7e04,
	0x02277e00,
	0x42008800,
	0x20008902,
	0x0099cf02,
/* 0x02c7: ctx_init_strand_loop */
	0xf608fe95,
	0x8ef6008e,
	0x808acf40,
	0xb606a5b6,
	0xeabb01a0,
	0x0480b600,
	0xf40192b6,
	0xe4b6e81b,
	0xf2efbc08,
	0x99f094bd,
	0x17008003,
	0x0009f602,
	0x00f804bd,
/* 0x02f8: error */
	0x02050080,
	0xbd000ff6,
	0x80010f04,
	0xf6030700,
	0x04bd000f,
/* 0x030e: init */
	0x04bd00f8,
	0x410007fe,
	0x11cf4200,
	0x0911e700,
	0x0814b601,
	0x020014fe,
	0x12004002,
	0xbd0002f6,
	0x05c94104,
	0xbd0010fe,
	0x07004024,
	0xbd0002f6,
	0x20034204,
	0x01010080,
	0xbd0002f6,
	0x20044204,
	0x01010480,
	0xbd0002f6,
	0x200b4204,
	0x01010880,
	0xbd0002f6,
	0x200c4204,
	0x01011c80,
	0xbd0002f6,
	0x01039204,
	0x03090080,
	0xbd0003f6,
	0x87044204,
	0xf6040040,
	0x04bd0002,
	0x00400402,
	0x0002f603,
	0x31f404bd,
	0x96048e10,
	0x00657e40,
	0xc7feb200,
	0x01b590f1,
	0x1ff4f003,
	0x01020fb5,
	0x041fbb01,
	0x800112b6,
	0xf6010300,
	0x04bd0001,
	0x01040080,
	0xbd0001f6,
	0x01004104,
	0xac7e020f,
	0xbb7e0006,
	0x100f0006,
	0x0006fd7e,
	0x98000e98,
	0x207e010f,
	0x14950001,
	0xc0008008,
	0x0004f601,
	0x008004bd,
	0x04f601c1,
	0xb704bd00,
	0xbb130030,
	0xf5b6001f,
	0xd3008002,
	0x000ff601,
	0x15b604bd,
	0x0110b608,
	0xb20814b6,
	0x02687e1f,
	0x001fbb00,
	0x84020398,
/* 0x041f: init_gpc */
	0xb8502000,
	0x0008044e,
	0x8f7e1fb2,
	0x4eb80000,
	0xbd00010c,
	0x008f7ef4,
	0x044eb800,
	0x8f7e0001,
	0x4eb80000,
	0x0f000100,
	0x008f7e02,
	0x004eb800,
/* 0x044e: init_gpc_wait */
	0x657e0008,
	0xffc80000,
	0xf90bf41f,
	0x08044eb8,
	0x00657e00,
	0x001fbb00,
	0x800040b7,
	0xf40132b6,
	0x000fb41b,
	0x0006fd7e,
	0xac7e000f,
	0x00800006,
	0x01f60201,
	0xbd04bd00,
	0x1f19f014,
	0x02300080,
	0xbd0001f6,
/* 0x0491: wait */
	0x0028f404,
/* 0x0497: main */
	0x0d0031f4,
	0x00377e10,
	0xf401f400,
	0x4001e4b1,
	0x00c71bf5,
	0x99f094bd,
	0x37008004,
	0x0009f602,
	0x008104bd,
	0x11cf02c0,
	0xc1008200,
	0x0022cf02,
	0xf41f13c8,
	0x23c8770b,
	0x550bf41f,
	0x12b220f9,
	0x99f094bd,
	0x37008007,
	0x0009f602,
	0x32f404bd,
	0x0231f401,
	0x0008807e,
	0x99f094bd,
	0x17008007,
	0x0009f602,
	0x20fc04bd,
	0x99f094bd,
	0x37008006,
	0x0009f602,
	0x31f404bd,
	0x08807e01,
	0xf094bd00,
	0x00800699,
	0x09f60217,
	0xf404bd00,
/* 0x0522: chsw_prev_no_next */
	0x20f92f0e,
	0x32f412b2,
	0x0232f401,
	0x0008807e,
	0x008020fc,
	0x02f602c0,
	0xf404bd00,
/* 0x053e: chsw_no_prev */
	0x23c8130e,
	0x0d0bf41f,
	0xf40131f4,
	0x807e0232,
/* 0x054e: chsw_done */
	0x01020008,
	0x02c30080,
	0xbd0002f6,
	0xf094bd04,
	0x00800499,
	0x09f60217,
	0xf504bd00,
/* 0x056b: main_not_ctx_switch */
	0xb0ff300e,
	0x1bf401e4,
	0x7ef2b20c,
	0xf4000820,
/* 0x057a: main_not_ctx_chan */
	0xe4b0400e,
	0x2c1bf402,
	0x99f094bd,
	0x37008007,
	0x0009f602,
	0x32f404bd,
	0x0232f401,
	0x0008807e,
	0x99f094bd,
	0x17008007,
	0x0009f602,
	0x0ef404bd,
/* 0x05a9: main_not_ctx_save */
	0x10ef9411,
	0x7e01f5f0,
	0xf50002f8,
/* 0x05b7: main_done */
	0xbdfee40e,
	0x1f29f024,
	0x02300080,
	0xbd0002f6,
	0xd20ef504,
/* 0x05c9: ih */
	0xf900f9fe,
	0x0188fe80,
	0x90f980f9,
	0xb0f9a0f9,
	0xe0f9d0f9,
	0x04bdf0f9,
	0xcf02004a,
	0xabc400aa,
	0x230bf404,
	0x004e100d,
	0x00eecf1a,
	0xcf19004f,
	0x047e00ff,
	0xb0b70000,
	0x010e0400,
	0xf61d0040,
	0x04bd000e,
/* 0x060c: ih_no_fifo */
	0x0100abe4,
	0x0d0c0bf4,
	0x40014e10,
	0x0000047e,
/* 0x061c: ih_no_ctxsw */
	0x0400abe4,
	0x8e560bf4,
	0x7e400708,
	0xb2000065,
	0x040080ff,
	0x000ff602,
	0x048e04bd,
	0x657e4007,
	0xffb20000,
	0x02030080,
	0xbd000ff6,
	0x50fec704,
	0x8f02ee94,
	0xbb400700,
	0x657e00ef,
	0x00800000,
	0x0ff60202,
	0x0f04bd00,
	0x02f87e03,
	0x01004b00,
	0x448ebfb2,
	0x8f7e4001,
/* 0x0676: ih_no_fwmthd */
	0x044b0000,
	0xffb0bd05,
	0x0bf4b4ab,
	0x0700800c,
	0x000bf603,
/* 0x068a: ih_no_other */
	0x004004bd,
	0x000af601,
	0xf0fc04bd,
	0xd0fce0fc,
	0xa0fcb0fc,
	0x80fc90fc,
	0xfc0088fe,
	0xf400fc80,
	0x01f80032,
/* 0x06ac: ctx_4170s */
	0xb210f5f0,
	0x41708eff,
	0x008f7e40,
/* 0x06bb: ctx_4170w */
	0x8e00f800,
	0x7e404170,
	0xb2000065,
	0x10f4f0ff,
	0xf8f31bf4,
/* 0x06cd: ctx_redswitch */
	0x02004e00,
	0xf040e5f0,
	0xe5f020e5,
	0x85008010,
	0x000ef601,
	0x080f04bd,
/* 0x06e4: ctx_redswitch_delay */
	0xf401f2b6,
	0xe5f1fd1b,
	0xe5f10400,
	0x00800100,
	0x0ef60185,
	0xf804bd00,
/* 0x06fd: ctx_86c */
	0x23008000,
	0x000ff602,
	0xffb204bd,
	0x408a148e,
	0x00008f7e,
	0x8c8effb2,
	0x8f7e41a8,
	0x00f80000,
/* 0x071c: ctx_mem */
	0x02840080,
	0xbd000ff6,
/* 0x0725: ctx_mem_wait */
	0x84008f04,
	0x00ffcf02,
	0xf405fffd,
	0x00f8f61b,
/* 0x0734: ctx_load */
	0x99f094bd,
	0x37008005,
	0x0009f602,
	0x0c0a04bd,
	0x0000b87e,
	0x0080f4bd,
	0x0ff60289,
	0x8004bd00,
	0xf602c100,
	0x04bd0002,
	0x02830080,
	0xbd0002f6,
	0x7e070f04,
	0x8000071c,
	0xf602c000,
	0x04bd0002,
	0xf0000bfe,
	0x24b61f2a,
	0x0220b604,
	0x99f094bd,
	0x37008008,
	0x0009f602,
	0x008004bd,
	0x02f60281,
	0xd204bd00,
	0x80000000,
	0x800225f0,
	0xf6028800,
	0x04bd0002,
	0x00421001,
	0x0223f002,
	0xf80512fa,
	0xf094bd03,
	0x00800899,
	0x09f60217,
	0x9804bd00,
	0x14b68101,
	0x80029818,
	0xfd0825b6,
	0x01b50512,
	0xf094bd16,
	0x00800999,
	0x09f60237,
	0x8004bd00,
	0xf6028100,
	0x04bd0001,
	0x00800102,
	0x02f60288,
	0x4104bd00,
	0x13f00100,
	0x0501fa06,
	0x94bd03f8,
	0x800999f0,
	0xf6021700,
	0x04bd0009,
	0x99f094bd,
	0x17008005,
	0x0009f602,
	0x00f804bd,
/* 0x0820: ctx_chan */
	0x0007347e,
	0xb87e0c0a,
	0x050f0000,
	0x00071c7e,
/* 0x0832: ctx_mmio_exec */
	0x039800f8,
	0x81008041,
	0x0003f602,
	0x34bd04bd,
/* 0x0840: ctx_mmio_loop */
	0xf4ff34c4,
	0x00450e1b,
	0x0653f002,
	0xf80535fa,
/* 0x0851: ctx_mmio_pull */
	0x804e9803,
	0x7e814f98,
	0xb600008f,
	0x12b60830,
	0xdf1bf401,
/* 0x0864: ctx_mmio_done */
	0x80160398,
	0xf6028100,
	0x04bd0003,
	0x414000b5,
	0x13f00100,
	0x0601fa06,
	0x00f803f8,
/* 0x0880: ctx_xfer */
	0x0080040e,
	0x0ef60302,
/* 0x088b: ctx_xfer_idle */
	0x8e04bd00,
	0xcf030000,
	0xe4f100ee,
	0x1bf42000,
	0x0611f4f5,
/* 0x089f: ctx_xfer_pre */
	0x0f0c02f4,
	0x06fd7e10,
	0x1b11f400,
/* 0x08a8: ctx_xfer_pre_load */
	0xac7e020f,
	0xbb7e0006,
	0xcd7e0006,
	0xf4bd0006,
	0x0006ac7e,
	0x0007347e,
/* 0x08c0: ctx_xfer_exec */
	0xbd160198,
	0x05008024,
	0x0002f601,
	0x1fb204bd,
	0x41a5008e,
	0x00008f7e,
	0xf001fcf0,
	0x24b6022c,
	0x05f2fd01,
	0x048effb2,
	0x8f7e41a5,
	0x167e0000,
	0x24bd0002,
	0x0247fc80,
	0xbd0002f6,
	0x012cf004,
	0x800320b6,
	0xf6024afc,
	0x04bd0002,
	0xf001acf0,
	0x000b06a5,
	0x98000c98,
	0x000e010d,
	0x00013d7e,
	0xec7e080a,
	0x0a7e0000,
	0x01f40002,
	0x7e0c0a12,
	0x0f0000b8,
	0x071c7e05,
	0x2d02f400,
/* 0x093c: ctx_xfer_post */
	0xac7e020f,
	0xf4bd0006,
	0x0006fd7e,
	0x0002277e,
	0x0006bb7e,
	0xac7ef4bd,
	0x11f40006,
	0x40019810,
	0xf40511fd,
	0x327e070b,
/* 0x0966: ctx_xfer_no_post_mmio */
/* 0x0966: ctx_xfer_done */
	0x00f80008,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
	0x00000000,
};
