
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0d3050ef          	jal	ra,800058e8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	e44e                	sd	s3,8(sp)
    80000028:	1800                	addi	s0,sp,48
  struct run *r;
  int temp;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002a:	03451793          	slli	a5,a0,0x34
    8000002e:	e3a5                	bnez	a5,8000008e <kfree+0x72>
    80000030:	84aa                	mv	s1,a0
    80000032:	00242797          	auipc	a5,0x242
    80000036:	d3e78793          	addi	a5,a5,-706 # 80241d70 <end>
    8000003a:	04f56a63          	bltu	a0,a5,8000008e <kfree+0x72>
    8000003e:	47c5                	li	a5,17
    80000040:	07ee                	slli	a5,a5,0x1b
    80000042:	04f57663          	bgeu	a0,a5,8000008e <kfree+0x72>
    panic("kfree");

  acquire(&ref_count_lock);
    80000046:	00009917          	auipc	s2,0x9
    8000004a:	89a90913          	addi	s2,s2,-1894 # 800088e0 <ref_count_lock>
    8000004e:	854a                	mv	a0,s2
    80000050:	00006097          	auipc	ra,0x6
    80000054:	284080e7          	jalr	644(ra) # 800062d4 <acquire>
  // decrease the reference count, if use reference is not zero, then return
  useReference[(uint64)pa/PGSIZE] -= 1;
    80000058:	00c4d713          	srli	a4,s1,0xc
    8000005c:	070a                	slli	a4,a4,0x2
    8000005e:	00009797          	auipc	a5,0x9
    80000062:	8ba78793          	addi	a5,a5,-1862 # 80008918 <useReference>
    80000066:	97ba                	add	a5,a5,a4
    80000068:	4398                	lw	a4,0(a5)
    8000006a:	377d                	addiw	a4,a4,-1
    8000006c:	0007099b          	sext.w	s3,a4
    80000070:	c398                	sw	a4,0(a5)
  temp = useReference[(uint64)pa/PGSIZE];
  release(&ref_count_lock);
    80000072:	854a                	mv	a0,s2
    80000074:	00006097          	auipc	ra,0x6
    80000078:	314080e7          	jalr	788(ra) # 80006388 <release>
  if (temp > 0)
    8000007c:	03305163          	blez	s3,8000009e <kfree+0x82>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    80000080:	70a2                	ld	ra,40(sp)
    80000082:	7402                	ld	s0,32(sp)
    80000084:	64e2                	ld	s1,24(sp)
    80000086:	6942                	ld	s2,16(sp)
    80000088:	69a2                	ld	s3,8(sp)
    8000008a:	6145                	addi	sp,sp,48
    8000008c:	8082                	ret
    panic("kfree");
    8000008e:	00008517          	auipc	a0,0x8
    80000092:	f8250513          	addi	a0,a0,-126 # 80008010 <etext+0x10>
    80000096:	00006097          	auipc	ra,0x6
    8000009a:	d06080e7          	jalr	-762(ra) # 80005d9c <panic>
  memset(pa, 1, PGSIZE);
    8000009e:	6605                	lui	a2,0x1
    800000a0:	4585                	li	a1,1
    800000a2:	8526                	mv	a0,s1
    800000a4:	00000097          	auipc	ra,0x0
    800000a8:	154080e7          	jalr	340(ra) # 800001f8 <memset>
  acquire(&kmem.lock);
    800000ac:	89ca                	mv	s3,s2
    800000ae:	00009917          	auipc	s2,0x9
    800000b2:	84a90913          	addi	s2,s2,-1974 # 800088f8 <kmem>
    800000b6:	854a                	mv	a0,s2
    800000b8:	00006097          	auipc	ra,0x6
    800000bc:	21c080e7          	jalr	540(ra) # 800062d4 <acquire>
  r->next = kmem.freelist;
    800000c0:	0309b783          	ld	a5,48(s3)
    800000c4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000c6:	0299b823          	sd	s1,48(s3)
  release(&kmem.lock);
    800000ca:	854a                	mv	a0,s2
    800000cc:	00006097          	auipc	ra,0x6
    800000d0:	2bc080e7          	jalr	700(ra) # 80006388 <release>
    800000d4:	b775                	j	80000080 <kfree+0x64>

00000000800000d6 <freerange>:
{
    800000d6:	7179                	addi	sp,sp,-48
    800000d8:	f406                	sd	ra,40(sp)
    800000da:	f022                	sd	s0,32(sp)
    800000dc:	ec26                	sd	s1,24(sp)
    800000de:	e84a                	sd	s2,16(sp)
    800000e0:	e44e                	sd	s3,8(sp)
    800000e2:	e052                	sd	s4,0(sp)
    800000e4:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000e6:	6785                	lui	a5,0x1
    800000e8:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000ec:	00e504b3          	add	s1,a0,a4
    800000f0:	777d                	lui	a4,0xfffff
    800000f2:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f4:	94be                	add	s1,s1,a5
    800000f6:	0095ee63          	bltu	a1,s1,80000112 <freerange+0x3c>
    800000fa:	892e                	mv	s2,a1
    kfree(p);
    800000fc:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000fe:	6985                	lui	s3,0x1
    kfree(p);
    80000100:	01448533          	add	a0,s1,s4
    80000104:	00000097          	auipc	ra,0x0
    80000108:	f18080e7          	jalr	-232(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000010c:	94ce                	add	s1,s1,s3
    8000010e:	fe9979e3          	bgeu	s2,s1,80000100 <freerange+0x2a>
}
    80000112:	70a2                	ld	ra,40(sp)
    80000114:	7402                	ld	s0,32(sp)
    80000116:	64e2                	ld	s1,24(sp)
    80000118:	6942                	ld	s2,16(sp)
    8000011a:	69a2                	ld	s3,8(sp)
    8000011c:	6a02                	ld	s4,0(sp)
    8000011e:	6145                	addi	sp,sp,48
    80000120:	8082                	ret

0000000080000122 <kinit>:
{
    80000122:	1141                	addi	sp,sp,-16
    80000124:	e406                	sd	ra,8(sp)
    80000126:	e022                	sd	s0,0(sp)
    80000128:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000012a:	00008597          	auipc	a1,0x8
    8000012e:	eee58593          	addi	a1,a1,-274 # 80008018 <etext+0x18>
    80000132:	00008517          	auipc	a0,0x8
    80000136:	7c650513          	addi	a0,a0,1990 # 800088f8 <kmem>
    8000013a:	00006097          	auipc	ra,0x6
    8000013e:	10a080e7          	jalr	266(ra) # 80006244 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000142:	45c5                	li	a1,17
    80000144:	05ee                	slli	a1,a1,0x1b
    80000146:	00242517          	auipc	a0,0x242
    8000014a:	c2a50513          	addi	a0,a0,-982 # 80241d70 <end>
    8000014e:	00000097          	auipc	ra,0x0
    80000152:	f88080e7          	jalr	-120(ra) # 800000d6 <freerange>
}
    80000156:	60a2                	ld	ra,8(sp)
    80000158:	6402                	ld	s0,0(sp)
    8000015a:	0141                	addi	sp,sp,16
    8000015c:	8082                	ret

000000008000015e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000015e:	1101                	addi	sp,sp,-32
    80000160:	ec06                	sd	ra,24(sp)
    80000162:	e822                	sd	s0,16(sp)
    80000164:	e426                	sd	s1,8(sp)
    80000166:	e04a                	sd	s2,0(sp)
    80000168:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000016a:	00008517          	auipc	a0,0x8
    8000016e:	78e50513          	addi	a0,a0,1934 # 800088f8 <kmem>
    80000172:	00006097          	auipc	ra,0x6
    80000176:	162080e7          	jalr	354(ra) # 800062d4 <acquire>
  r = kmem.freelist;
    8000017a:	00008497          	auipc	s1,0x8
    8000017e:	7964b483          	ld	s1,1942(s1) # 80008910 <kmem+0x18>
  if(r) {
    80000182:	c0b5                	beqz	s1,800001e6 <kalloc+0x88>
    kmem.freelist = r->next;
    80000184:	609c                	ld	a5,0(s1)
    80000186:	00008917          	auipc	s2,0x8
    8000018a:	75a90913          	addi	s2,s2,1882 # 800088e0 <ref_count_lock>
    8000018e:	02f93823          	sd	a5,48(s2)
    acquire(&ref_count_lock);
    80000192:	854a                	mv	a0,s2
    80000194:	00006097          	auipc	ra,0x6
    80000198:	140080e7          	jalr	320(ra) # 800062d4 <acquire>
    // initialization the ref count to 1
    useReference[(uint64)r / PGSIZE] = 1;
    8000019c:	00c4d713          	srli	a4,s1,0xc
    800001a0:	070a                	slli	a4,a4,0x2
    800001a2:	00008797          	auipc	a5,0x8
    800001a6:	77678793          	addi	a5,a5,1910 # 80008918 <useReference>
    800001aa:	97ba                	add	a5,a5,a4
    800001ac:	4705                	li	a4,1
    800001ae:	c398                	sw	a4,0(a5)
    release(&ref_count_lock);
    800001b0:	854a                	mv	a0,s2
    800001b2:	00006097          	auipc	ra,0x6
    800001b6:	1d6080e7          	jalr	470(ra) # 80006388 <release>
  }
  release(&kmem.lock);
    800001ba:	00008517          	auipc	a0,0x8
    800001be:	73e50513          	addi	a0,a0,1854 # 800088f8 <kmem>
    800001c2:	00006097          	auipc	ra,0x6
    800001c6:	1c6080e7          	jalr	454(ra) # 80006388 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001ca:	6605                	lui	a2,0x1
    800001cc:	4595                	li	a1,5
    800001ce:	8526                	mv	a0,s1
    800001d0:	00000097          	auipc	ra,0x0
    800001d4:	028080e7          	jalr	40(ra) # 800001f8 <memset>
  return (void*)r;
}
    800001d8:	8526                	mv	a0,s1
    800001da:	60e2                	ld	ra,24(sp)
    800001dc:	6442                	ld	s0,16(sp)
    800001de:	64a2                	ld	s1,8(sp)
    800001e0:	6902                	ld	s2,0(sp)
    800001e2:	6105                	addi	sp,sp,32
    800001e4:	8082                	ret
  release(&kmem.lock);
    800001e6:	00008517          	auipc	a0,0x8
    800001ea:	71250513          	addi	a0,a0,1810 # 800088f8 <kmem>
    800001ee:	00006097          	auipc	ra,0x6
    800001f2:	19a080e7          	jalr	410(ra) # 80006388 <release>
  if(r)
    800001f6:	b7cd                	j	800001d8 <kalloc+0x7a>

00000000800001f8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001f8:	1141                	addi	sp,sp,-16
    800001fa:	e422                	sd	s0,8(sp)
    800001fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001fe:	ca19                	beqz	a2,80000214 <memset+0x1c>
    80000200:	87aa                	mv	a5,a0
    80000202:	1602                	slli	a2,a2,0x20
    80000204:	9201                	srli	a2,a2,0x20
    80000206:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000020a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000020e:	0785                	addi	a5,a5,1
    80000210:	fee79de3          	bne	a5,a4,8000020a <memset+0x12>
  }
  return dst;
}
    80000214:	6422                	ld	s0,8(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000220:	ca05                	beqz	a2,80000250 <memcmp+0x36>
    80000222:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000226:	1682                	slli	a3,a3,0x20
    80000228:	9281                	srli	a3,a3,0x20
    8000022a:	0685                	addi	a3,a3,1
    8000022c:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000022e:	00054783          	lbu	a5,0(a0)
    80000232:	0005c703          	lbu	a4,0(a1)
    80000236:	00e79863          	bne	a5,a4,80000246 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    8000023a:	0505                	addi	a0,a0,1
    8000023c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000023e:	fed518e3          	bne	a0,a3,8000022e <memcmp+0x14>
  }

  return 0;
    80000242:	4501                	li	a0,0
    80000244:	a019                	j	8000024a <memcmp+0x30>
      return *s1 - *s2;
    80000246:	40e7853b          	subw	a0,a5,a4
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret
  return 0;
    80000250:	4501                	li	a0,0
    80000252:	bfe5                	j	8000024a <memcmp+0x30>

0000000080000254 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000254:	1141                	addi	sp,sp,-16
    80000256:	e422                	sd	s0,8(sp)
    80000258:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000025a:	c205                	beqz	a2,8000027a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000025c:	02a5e263          	bltu	a1,a0,80000280 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000260:	1602                	slli	a2,a2,0x20
    80000262:	9201                	srli	a2,a2,0x20
    80000264:	00c587b3          	add	a5,a1,a2
{
    80000268:	872a                	mv	a4,a0
      *d++ = *s++;
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdbd291>
    8000026e:	fff5c683          	lbu	a3,-1(a1)
    80000272:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000276:	fef59ae3          	bne	a1,a5,8000026a <memmove+0x16>

  return dst;
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret
  if(s < d && s + n > d){
    80000280:	02061693          	slli	a3,a2,0x20
    80000284:	9281                	srli	a3,a3,0x20
    80000286:	00d58733          	add	a4,a1,a3
    8000028a:	fce57be3          	bgeu	a0,a4,80000260 <memmove+0xc>
    d += n;
    8000028e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000290:	fff6079b          	addiw	a5,a2,-1
    80000294:	1782                	slli	a5,a5,0x20
    80000296:	9381                	srli	a5,a5,0x20
    80000298:	fff7c793          	not	a5,a5
    8000029c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000029e:	177d                	addi	a4,a4,-1
    800002a0:	16fd                	addi	a3,a3,-1
    800002a2:	00074603          	lbu	a2,0(a4)
    800002a6:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800002aa:	fee79ae3          	bne	a5,a4,8000029e <memmove+0x4a>
    800002ae:	b7f1                	j	8000027a <memmove+0x26>

00000000800002b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800002b0:	1141                	addi	sp,sp,-16
    800002b2:	e406                	sd	ra,8(sp)
    800002b4:	e022                	sd	s0,0(sp)
    800002b6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002b8:	00000097          	auipc	ra,0x0
    800002bc:	f9c080e7          	jalr	-100(ra) # 80000254 <memmove>
}
    800002c0:	60a2                	ld	ra,8(sp)
    800002c2:	6402                	ld	s0,0(sp)
    800002c4:	0141                	addi	sp,sp,16
    800002c6:	8082                	ret

00000000800002c8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800002c8:	1141                	addi	sp,sp,-16
    800002ca:	e422                	sd	s0,8(sp)
    800002cc:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002ce:	ce11                	beqz	a2,800002ea <strncmp+0x22>
    800002d0:	00054783          	lbu	a5,0(a0)
    800002d4:	cf89                	beqz	a5,800002ee <strncmp+0x26>
    800002d6:	0005c703          	lbu	a4,0(a1)
    800002da:	00f71a63          	bne	a4,a5,800002ee <strncmp+0x26>
    n--, p++, q++;
    800002de:	367d                	addiw	a2,a2,-1
    800002e0:	0505                	addi	a0,a0,1
    800002e2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002e4:	f675                	bnez	a2,800002d0 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002e6:	4501                	li	a0,0
    800002e8:	a809                	j	800002fa <strncmp+0x32>
    800002ea:	4501                	li	a0,0
    800002ec:	a039                	j	800002fa <strncmp+0x32>
  if(n == 0)
    800002ee:	ca09                	beqz	a2,80000300 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002f0:	00054503          	lbu	a0,0(a0)
    800002f4:	0005c783          	lbu	a5,0(a1)
    800002f8:	9d1d                	subw	a0,a0,a5
}
    800002fa:	6422                	ld	s0,8(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret
    return 0;
    80000300:	4501                	li	a0,0
    80000302:	bfe5                	j	800002fa <strncmp+0x32>

0000000080000304 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e422                	sd	s0,8(sp)
    80000308:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000030a:	872a                	mv	a4,a0
    8000030c:	8832                	mv	a6,a2
    8000030e:	367d                	addiw	a2,a2,-1
    80000310:	01005963          	blez	a6,80000322 <strncpy+0x1e>
    80000314:	0705                	addi	a4,a4,1
    80000316:	0005c783          	lbu	a5,0(a1)
    8000031a:	fef70fa3          	sb	a5,-1(a4)
    8000031e:	0585                	addi	a1,a1,1
    80000320:	f7f5                	bnez	a5,8000030c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000322:	86ba                	mv	a3,a4
    80000324:	00c05c63          	blez	a2,8000033c <strncpy+0x38>
    *s++ = 0;
    80000328:	0685                	addi	a3,a3,1
    8000032a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    8000032e:	40d707bb          	subw	a5,a4,a3
    80000332:	37fd                	addiw	a5,a5,-1
    80000334:	010787bb          	addw	a5,a5,a6
    80000338:	fef048e3          	bgtz	a5,80000328 <strncpy+0x24>
  return os;
}
    8000033c:	6422                	ld	s0,8(sp)
    8000033e:	0141                	addi	sp,sp,16
    80000340:	8082                	ret

0000000080000342 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000342:	1141                	addi	sp,sp,-16
    80000344:	e422                	sd	s0,8(sp)
    80000346:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000348:	02c05363          	blez	a2,8000036e <safestrcpy+0x2c>
    8000034c:	fff6069b          	addiw	a3,a2,-1
    80000350:	1682                	slli	a3,a3,0x20
    80000352:	9281                	srli	a3,a3,0x20
    80000354:	96ae                	add	a3,a3,a1
    80000356:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000358:	00d58963          	beq	a1,a3,8000036a <safestrcpy+0x28>
    8000035c:	0585                	addi	a1,a1,1
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff5c703          	lbu	a4,-1(a1)
    80000364:	fee78fa3          	sb	a4,-1(a5)
    80000368:	fb65                	bnez	a4,80000358 <safestrcpy+0x16>
    ;
  *s = 0;
    8000036a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000036e:	6422                	ld	s0,8(sp)
    80000370:	0141                	addi	sp,sp,16
    80000372:	8082                	ret

0000000080000374 <strlen>:

int
strlen(const char *s)
{
    80000374:	1141                	addi	sp,sp,-16
    80000376:	e422                	sd	s0,8(sp)
    80000378:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000037a:	00054783          	lbu	a5,0(a0)
    8000037e:	cf91                	beqz	a5,8000039a <strlen+0x26>
    80000380:	0505                	addi	a0,a0,1
    80000382:	87aa                	mv	a5,a0
    80000384:	4685                	li	a3,1
    80000386:	9e89                	subw	a3,a3,a0
    80000388:	00f6853b          	addw	a0,a3,a5
    8000038c:	0785                	addi	a5,a5,1
    8000038e:	fff7c703          	lbu	a4,-1(a5)
    80000392:	fb7d                	bnez	a4,80000388 <strlen+0x14>
    ;
  return n;
}
    80000394:	6422                	ld	s0,8(sp)
    80000396:	0141                	addi	sp,sp,16
    80000398:	8082                	ret
  for(n = 0; s[n]; n++)
    8000039a:	4501                	li	a0,0
    8000039c:	bfe5                	j	80000394 <strlen+0x20>

000000008000039e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000039e:	1141                	addi	sp,sp,-16
    800003a0:	e406                	sd	ra,8(sp)
    800003a2:	e022                	sd	s0,0(sp)
    800003a4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800003a6:	00001097          	auipc	ra,0x1
    800003aa:	bd8080e7          	jalr	-1064(ra) # 80000f7e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800003ae:	00008717          	auipc	a4,0x8
    800003b2:	50270713          	addi	a4,a4,1282 # 800088b0 <started>
  if(cpuid() == 0){
    800003b6:	c139                	beqz	a0,800003fc <main+0x5e>
    while(started == 0)
    800003b8:	431c                	lw	a5,0(a4)
    800003ba:	2781                	sext.w	a5,a5
    800003bc:	dff5                	beqz	a5,800003b8 <main+0x1a>
      ;
    __sync_synchronize();
    800003be:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800003c2:	00001097          	auipc	ra,0x1
    800003c6:	bbc080e7          	jalr	-1092(ra) # 80000f7e <cpuid>
    800003ca:	85aa                	mv	a1,a0
    800003cc:	00008517          	auipc	a0,0x8
    800003d0:	c6c50513          	addi	a0,a0,-916 # 80008038 <etext+0x38>
    800003d4:	00006097          	auipc	ra,0x6
    800003d8:	a12080e7          	jalr	-1518(ra) # 80005de6 <printf>
    kvminithart();    // turn on paging
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	0d8080e7          	jalr	216(ra) # 800004b4 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	864080e7          	jalr	-1948(ra) # 80001c48 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003ec:	00005097          	auipc	ra,0x5
    800003f0:	eb4080e7          	jalr	-332(ra) # 800052a0 <plicinithart>
  }

  scheduler();        
    800003f4:	00001097          	auipc	ra,0x1
    800003f8:	0ac080e7          	jalr	172(ra) # 800014a0 <scheduler>
    consoleinit();
    800003fc:	00006097          	auipc	ra,0x6
    80000400:	8b0080e7          	jalr	-1872(ra) # 80005cac <consoleinit>
    printfinit();
    80000404:	00006097          	auipc	ra,0x6
    80000408:	bc2080e7          	jalr	-1086(ra) # 80005fc6 <printfinit>
    printf("\n");
    8000040c:	00008517          	auipc	a0,0x8
    80000410:	c3c50513          	addi	a0,a0,-964 # 80008048 <etext+0x48>
    80000414:	00006097          	auipc	ra,0x6
    80000418:	9d2080e7          	jalr	-1582(ra) # 80005de6 <printf>
    printf("xv6 kernel is booting\n");
    8000041c:	00008517          	auipc	a0,0x8
    80000420:	c0450513          	addi	a0,a0,-1020 # 80008020 <etext+0x20>
    80000424:	00006097          	auipc	ra,0x6
    80000428:	9c2080e7          	jalr	-1598(ra) # 80005de6 <printf>
    printf("\n");
    8000042c:	00008517          	auipc	a0,0x8
    80000430:	c1c50513          	addi	a0,a0,-996 # 80008048 <etext+0x48>
    80000434:	00006097          	auipc	ra,0x6
    80000438:	9b2080e7          	jalr	-1614(ra) # 80005de6 <printf>
    kinit();         // physical page allocator
    8000043c:	00000097          	auipc	ra,0x0
    80000440:	ce6080e7          	jalr	-794(ra) # 80000122 <kinit>
    kvminit();       // create kernel page table
    80000444:	00000097          	auipc	ra,0x0
    80000448:	326080e7          	jalr	806(ra) # 8000076a <kvminit>
    kvminithart();   // turn on paging
    8000044c:	00000097          	auipc	ra,0x0
    80000450:	068080e7          	jalr	104(ra) # 800004b4 <kvminithart>
    procinit();      // process table
    80000454:	00001097          	auipc	ra,0x1
    80000458:	a78080e7          	jalr	-1416(ra) # 80000ecc <procinit>
    trapinit();      // trap vectors
    8000045c:	00001097          	auipc	ra,0x1
    80000460:	7c4080e7          	jalr	1988(ra) # 80001c20 <trapinit>
    trapinithart();  // install kernel trap vector
    80000464:	00001097          	auipc	ra,0x1
    80000468:	7e4080e7          	jalr	2020(ra) # 80001c48 <trapinithart>
    plicinit();      // set up interrupt controller
    8000046c:	00005097          	auipc	ra,0x5
    80000470:	e1e080e7          	jalr	-482(ra) # 8000528a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000474:	00005097          	auipc	ra,0x5
    80000478:	e2c080e7          	jalr	-468(ra) # 800052a0 <plicinithart>
    binit();         // buffer cache
    8000047c:	00002097          	auipc	ra,0x2
    80000480:	fc6080e7          	jalr	-58(ra) # 80002442 <binit>
    iinit();         // inode table
    80000484:	00002097          	auipc	ra,0x2
    80000488:	666080e7          	jalr	1638(ra) # 80002aea <iinit>
    fileinit();      // file table
    8000048c:	00003097          	auipc	ra,0x3
    80000490:	60c080e7          	jalr	1548(ra) # 80003a98 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000494:	00005097          	auipc	ra,0x5
    80000498:	f14080e7          	jalr	-236(ra) # 800053a8 <virtio_disk_init>
    userinit();      // first user process
    8000049c:	00001097          	auipc	ra,0x1
    800004a0:	de6080e7          	jalr	-538(ra) # 80001282 <userinit>
    __sync_synchronize();
    800004a4:	0ff0000f          	fence
    started = 1;
    800004a8:	4785                	li	a5,1
    800004aa:	00008717          	auipc	a4,0x8
    800004ae:	40f72323          	sw	a5,1030(a4) # 800088b0 <started>
    800004b2:	b789                	j	800003f4 <main+0x56>

00000000800004b4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800004b4:	1141                	addi	sp,sp,-16
    800004b6:	e422                	sd	s0,8(sp)
    800004b8:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004ba:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800004be:	00008797          	auipc	a5,0x8
    800004c2:	3fa7b783          	ld	a5,1018(a5) # 800088b8 <kernel_pagetable>
    800004c6:	83b1                	srli	a5,a5,0xc
    800004c8:	577d                	li	a4,-1
    800004ca:	177e                	slli	a4,a4,0x3f
    800004cc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800004ce:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004d2:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004d6:	6422                	ld	s0,8(sp)
    800004d8:	0141                	addi	sp,sp,16
    800004da:	8082                	ret

00000000800004dc <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004dc:	7139                	addi	sp,sp,-64
    800004de:	fc06                	sd	ra,56(sp)
    800004e0:	f822                	sd	s0,48(sp)
    800004e2:	f426                	sd	s1,40(sp)
    800004e4:	f04a                	sd	s2,32(sp)
    800004e6:	ec4e                	sd	s3,24(sp)
    800004e8:	e852                	sd	s4,16(sp)
    800004ea:	e456                	sd	s5,8(sp)
    800004ec:	e05a                	sd	s6,0(sp)
    800004ee:	0080                	addi	s0,sp,64
    800004f0:	84aa                	mv	s1,a0
    800004f2:	89ae                	mv	s3,a1
    800004f4:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004f6:	57fd                	li	a5,-1
    800004f8:	83e9                	srli	a5,a5,0x1a
    800004fa:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004fc:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004fe:	04b7f263          	bgeu	a5,a1,80000542 <walk+0x66>
    panic("walk");
    80000502:	00008517          	auipc	a0,0x8
    80000506:	b4e50513          	addi	a0,a0,-1202 # 80008050 <etext+0x50>
    8000050a:	00006097          	auipc	ra,0x6
    8000050e:	892080e7          	jalr	-1902(ra) # 80005d9c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000512:	060a8663          	beqz	s5,8000057e <walk+0xa2>
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	c48080e7          	jalr	-952(ra) # 8000015e <kalloc>
    8000051e:	84aa                	mv	s1,a0
    80000520:	c529                	beqz	a0,8000056a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000522:	6605                	lui	a2,0x1
    80000524:	4581                	li	a1,0
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	cd2080e7          	jalr	-814(ra) # 800001f8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000052e:	00c4d793          	srli	a5,s1,0xc
    80000532:	07aa                	slli	a5,a5,0xa
    80000534:	0017e793          	ori	a5,a5,1
    80000538:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000053c:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7fdbd287>
    8000053e:	036a0063          	beq	s4,s6,8000055e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000542:	0149d933          	srl	s2,s3,s4
    80000546:	1ff97913          	andi	s2,s2,511
    8000054a:	090e                	slli	s2,s2,0x3
    8000054c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000054e:	00093483          	ld	s1,0(s2)
    80000552:	0014f793          	andi	a5,s1,1
    80000556:	dfd5                	beqz	a5,80000512 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000558:	80a9                	srli	s1,s1,0xa
    8000055a:	04b2                	slli	s1,s1,0xc
    8000055c:	b7c5                	j	8000053c <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000055e:	00c9d513          	srli	a0,s3,0xc
    80000562:	1ff57513          	andi	a0,a0,511
    80000566:	050e                	slli	a0,a0,0x3
    80000568:	9526                	add	a0,a0,s1
}
    8000056a:	70e2                	ld	ra,56(sp)
    8000056c:	7442                	ld	s0,48(sp)
    8000056e:	74a2                	ld	s1,40(sp)
    80000570:	7902                	ld	s2,32(sp)
    80000572:	69e2                	ld	s3,24(sp)
    80000574:	6a42                	ld	s4,16(sp)
    80000576:	6aa2                	ld	s5,8(sp)
    80000578:	6b02                	ld	s6,0(sp)
    8000057a:	6121                	addi	sp,sp,64
    8000057c:	8082                	ret
        return 0;
    8000057e:	4501                	li	a0,0
    80000580:	b7ed                	j	8000056a <walk+0x8e>

0000000080000582 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000582:	57fd                	li	a5,-1
    80000584:	83e9                	srli	a5,a5,0x1a
    80000586:	00b7f463          	bgeu	a5,a1,8000058e <walkaddr+0xc>
    return 0;
    8000058a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000058c:	8082                	ret
{
    8000058e:	1141                	addi	sp,sp,-16
    80000590:	e406                	sd	ra,8(sp)
    80000592:	e022                	sd	s0,0(sp)
    80000594:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000596:	4601                	li	a2,0
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	f44080e7          	jalr	-188(ra) # 800004dc <walk>
  if(pte == 0)
    800005a0:	c105                	beqz	a0,800005c0 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800005a2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800005a4:	0117f693          	andi	a3,a5,17
    800005a8:	4745                	li	a4,17
    return 0;
    800005aa:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800005ac:	00e68663          	beq	a3,a4,800005b8 <walkaddr+0x36>
}
    800005b0:	60a2                	ld	ra,8(sp)
    800005b2:	6402                	ld	s0,0(sp)
    800005b4:	0141                	addi	sp,sp,16
    800005b6:	8082                	ret
  pa = PTE2PA(*pte);
    800005b8:	83a9                	srli	a5,a5,0xa
    800005ba:	00c79513          	slli	a0,a5,0xc
  return pa;
    800005be:	bfcd                	j	800005b0 <walkaddr+0x2e>
    return 0;
    800005c0:	4501                	li	a0,0
    800005c2:	b7fd                	j	800005b0 <walkaddr+0x2e>

00000000800005c4 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005c4:	715d                	addi	sp,sp,-80
    800005c6:	e486                	sd	ra,72(sp)
    800005c8:	e0a2                	sd	s0,64(sp)
    800005ca:	fc26                	sd	s1,56(sp)
    800005cc:	f84a                	sd	s2,48(sp)
    800005ce:	f44e                	sd	s3,40(sp)
    800005d0:	f052                	sd	s4,32(sp)
    800005d2:	ec56                	sd	s5,24(sp)
    800005d4:	e85a                	sd	s6,16(sp)
    800005d6:	e45e                	sd	s7,8(sp)
    800005d8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005da:	c639                	beqz	a2,80000628 <mappages+0x64>
    800005dc:	8aaa                	mv	s5,a0
    800005de:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005e0:	777d                	lui	a4,0xfffff
    800005e2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005e6:	fff58993          	addi	s3,a1,-1
    800005ea:	99b2                	add	s3,s3,a2
    800005ec:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005f0:	893e                	mv	s2,a5
    800005f2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005f6:	6b85                	lui	s7,0x1
    800005f8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005fc:	4605                	li	a2,1
    800005fe:	85ca                	mv	a1,s2
    80000600:	8556                	mv	a0,s5
    80000602:	00000097          	auipc	ra,0x0
    80000606:	eda080e7          	jalr	-294(ra) # 800004dc <walk>
    8000060a:	cd1d                	beqz	a0,80000648 <mappages+0x84>
    if(*pte & PTE_V)
    8000060c:	611c                	ld	a5,0(a0)
    8000060e:	8b85                	andi	a5,a5,1
    80000610:	e785                	bnez	a5,80000638 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000612:	80b1                	srli	s1,s1,0xc
    80000614:	04aa                	slli	s1,s1,0xa
    80000616:	0164e4b3          	or	s1,s1,s6
    8000061a:	0014e493          	ori	s1,s1,1
    8000061e:	e104                	sd	s1,0(a0)
    if(a == last)
    80000620:	05390063          	beq	s2,s3,80000660 <mappages+0x9c>
    a += PGSIZE;
    80000624:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000626:	bfc9                	j	800005f8 <mappages+0x34>
    panic("mappages: size");
    80000628:	00008517          	auipc	a0,0x8
    8000062c:	a3050513          	addi	a0,a0,-1488 # 80008058 <etext+0x58>
    80000630:	00005097          	auipc	ra,0x5
    80000634:	76c080e7          	jalr	1900(ra) # 80005d9c <panic>
      panic("mappages: remap");
    80000638:	00008517          	auipc	a0,0x8
    8000063c:	a3050513          	addi	a0,a0,-1488 # 80008068 <etext+0x68>
    80000640:	00005097          	auipc	ra,0x5
    80000644:	75c080e7          	jalr	1884(ra) # 80005d9c <panic>
      return -1;
    80000648:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000064a:	60a6                	ld	ra,72(sp)
    8000064c:	6406                	ld	s0,64(sp)
    8000064e:	74e2                	ld	s1,56(sp)
    80000650:	7942                	ld	s2,48(sp)
    80000652:	79a2                	ld	s3,40(sp)
    80000654:	7a02                	ld	s4,32(sp)
    80000656:	6ae2                	ld	s5,24(sp)
    80000658:	6b42                	ld	s6,16(sp)
    8000065a:	6ba2                	ld	s7,8(sp)
    8000065c:	6161                	addi	sp,sp,80
    8000065e:	8082                	ret
  return 0;
    80000660:	4501                	li	a0,0
    80000662:	b7e5                	j	8000064a <mappages+0x86>

0000000080000664 <kvmmap>:
{
    80000664:	1141                	addi	sp,sp,-16
    80000666:	e406                	sd	ra,8(sp)
    80000668:	e022                	sd	s0,0(sp)
    8000066a:	0800                	addi	s0,sp,16
    8000066c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000066e:	86b2                	mv	a3,a2
    80000670:	863e                	mv	a2,a5
    80000672:	00000097          	auipc	ra,0x0
    80000676:	f52080e7          	jalr	-174(ra) # 800005c4 <mappages>
    8000067a:	e509                	bnez	a0,80000684 <kvmmap+0x20>
}
    8000067c:	60a2                	ld	ra,8(sp)
    8000067e:	6402                	ld	s0,0(sp)
    80000680:	0141                	addi	sp,sp,16
    80000682:	8082                	ret
    panic("kvmmap");
    80000684:	00008517          	auipc	a0,0x8
    80000688:	9f450513          	addi	a0,a0,-1548 # 80008078 <etext+0x78>
    8000068c:	00005097          	auipc	ra,0x5
    80000690:	710080e7          	jalr	1808(ra) # 80005d9c <panic>

0000000080000694 <kvmmake>:
{
    80000694:	1101                	addi	sp,sp,-32
    80000696:	ec06                	sd	ra,24(sp)
    80000698:	e822                	sd	s0,16(sp)
    8000069a:	e426                	sd	s1,8(sp)
    8000069c:	e04a                	sd	s2,0(sp)
    8000069e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	abe080e7          	jalr	-1346(ra) # 8000015e <kalloc>
    800006a8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006aa:	6605                	lui	a2,0x1
    800006ac:	4581                	li	a1,0
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	b4a080e7          	jalr	-1206(ra) # 800001f8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006b6:	4719                	li	a4,6
    800006b8:	6685                	lui	a3,0x1
    800006ba:	10000637          	lui	a2,0x10000
    800006be:	100005b7          	lui	a1,0x10000
    800006c2:	8526                	mv	a0,s1
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	fa0080e7          	jalr	-96(ra) # 80000664 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006cc:	4719                	li	a4,6
    800006ce:	6685                	lui	a3,0x1
    800006d0:	10001637          	lui	a2,0x10001
    800006d4:	100015b7          	lui	a1,0x10001
    800006d8:	8526                	mv	a0,s1
    800006da:	00000097          	auipc	ra,0x0
    800006de:	f8a080e7          	jalr	-118(ra) # 80000664 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006e2:	4719                	li	a4,6
    800006e4:	004006b7          	lui	a3,0x400
    800006e8:	0c000637          	lui	a2,0xc000
    800006ec:	0c0005b7          	lui	a1,0xc000
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f72080e7          	jalr	-142(ra) # 80000664 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006fa:	00008917          	auipc	s2,0x8
    800006fe:	90690913          	addi	s2,s2,-1786 # 80008000 <etext>
    80000702:	4729                	li	a4,10
    80000704:	80008697          	auipc	a3,0x80008
    80000708:	8fc68693          	addi	a3,a3,-1796 # 8000 <_entry-0x7fff8000>
    8000070c:	4605                	li	a2,1
    8000070e:	067e                	slli	a2,a2,0x1f
    80000710:	85b2                	mv	a1,a2
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f50080e7          	jalr	-176(ra) # 80000664 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000071c:	4719                	li	a4,6
    8000071e:	46c5                	li	a3,17
    80000720:	06ee                	slli	a3,a3,0x1b
    80000722:	412686b3          	sub	a3,a3,s2
    80000726:	864a                	mv	a2,s2
    80000728:	85ca                	mv	a1,s2
    8000072a:	8526                	mv	a0,s1
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	f38080e7          	jalr	-200(ra) # 80000664 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000734:	4729                	li	a4,10
    80000736:	6685                	lui	a3,0x1
    80000738:	00007617          	auipc	a2,0x7
    8000073c:	8c860613          	addi	a2,a2,-1848 # 80007000 <_trampoline>
    80000740:	040005b7          	lui	a1,0x4000
    80000744:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000746:	05b2                	slli	a1,a1,0xc
    80000748:	8526                	mv	a0,s1
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	f1a080e7          	jalr	-230(ra) # 80000664 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000752:	8526                	mv	a0,s1
    80000754:	00000097          	auipc	ra,0x0
    80000758:	6e4080e7          	jalr	1764(ra) # 80000e38 <proc_mapstacks>
}
    8000075c:	8526                	mv	a0,s1
    8000075e:	60e2                	ld	ra,24(sp)
    80000760:	6442                	ld	s0,16(sp)
    80000762:	64a2                	ld	s1,8(sp)
    80000764:	6902                	ld	s2,0(sp)
    80000766:	6105                	addi	sp,sp,32
    80000768:	8082                	ret

000000008000076a <kvminit>:
{
    8000076a:	1141                	addi	sp,sp,-16
    8000076c:	e406                	sd	ra,8(sp)
    8000076e:	e022                	sd	s0,0(sp)
    80000770:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000772:	00000097          	auipc	ra,0x0
    80000776:	f22080e7          	jalr	-222(ra) # 80000694 <kvmmake>
    8000077a:	00008797          	auipc	a5,0x8
    8000077e:	12a7bf23          	sd	a0,318(a5) # 800088b8 <kernel_pagetable>
}
    80000782:	60a2                	ld	ra,8(sp)
    80000784:	6402                	ld	s0,0(sp)
    80000786:	0141                	addi	sp,sp,16
    80000788:	8082                	ret

000000008000078a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000078a:	715d                	addi	sp,sp,-80
    8000078c:	e486                	sd	ra,72(sp)
    8000078e:	e0a2                	sd	s0,64(sp)
    80000790:	fc26                	sd	s1,56(sp)
    80000792:	f84a                	sd	s2,48(sp)
    80000794:	f44e                	sd	s3,40(sp)
    80000796:	f052                	sd	s4,32(sp)
    80000798:	ec56                	sd	s5,24(sp)
    8000079a:	e85a                	sd	s6,16(sp)
    8000079c:	e45e                	sd	s7,8(sp)
    8000079e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800007a0:	03459793          	slli	a5,a1,0x34
    800007a4:	e795                	bnez	a5,800007d0 <uvmunmap+0x46>
    800007a6:	8a2a                	mv	s4,a0
    800007a8:	892e                	mv	s2,a1
    800007aa:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ac:	0632                	slli	a2,a2,0xc
    800007ae:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007b4:	6b05                	lui	s6,0x1
    800007b6:	0735e263          	bltu	a1,s3,8000081a <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800007ba:	60a6                	ld	ra,72(sp)
    800007bc:	6406                	ld	s0,64(sp)
    800007be:	74e2                	ld	s1,56(sp)
    800007c0:	7942                	ld	s2,48(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	7a02                	ld	s4,32(sp)
    800007c6:	6ae2                	ld	s5,24(sp)
    800007c8:	6b42                	ld	s6,16(sp)
    800007ca:	6ba2                	ld	s7,8(sp)
    800007cc:	6161                	addi	sp,sp,80
    800007ce:	8082                	ret
    panic("uvmunmap: not aligned");
    800007d0:	00008517          	auipc	a0,0x8
    800007d4:	8b050513          	addi	a0,a0,-1872 # 80008080 <etext+0x80>
    800007d8:	00005097          	auipc	ra,0x5
    800007dc:	5c4080e7          	jalr	1476(ra) # 80005d9c <panic>
      panic("uvmunmap: walk");
    800007e0:	00008517          	auipc	a0,0x8
    800007e4:	8b850513          	addi	a0,a0,-1864 # 80008098 <etext+0x98>
    800007e8:	00005097          	auipc	ra,0x5
    800007ec:	5b4080e7          	jalr	1460(ra) # 80005d9c <panic>
      panic("uvmunmap: not mapped");
    800007f0:	00008517          	auipc	a0,0x8
    800007f4:	8b850513          	addi	a0,a0,-1864 # 800080a8 <etext+0xa8>
    800007f8:	00005097          	auipc	ra,0x5
    800007fc:	5a4080e7          	jalr	1444(ra) # 80005d9c <panic>
      panic("uvmunmap: not a leaf");
    80000800:	00008517          	auipc	a0,0x8
    80000804:	8c050513          	addi	a0,a0,-1856 # 800080c0 <etext+0xc0>
    80000808:	00005097          	auipc	ra,0x5
    8000080c:	594080e7          	jalr	1428(ra) # 80005d9c <panic>
    *pte = 0;
    80000810:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000814:	995a                	add	s2,s2,s6
    80000816:	fb3972e3          	bgeu	s2,s3,800007ba <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000081a:	4601                	li	a2,0
    8000081c:	85ca                	mv	a1,s2
    8000081e:	8552                	mv	a0,s4
    80000820:	00000097          	auipc	ra,0x0
    80000824:	cbc080e7          	jalr	-836(ra) # 800004dc <walk>
    80000828:	84aa                	mv	s1,a0
    8000082a:	d95d                	beqz	a0,800007e0 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000082c:	6108                	ld	a0,0(a0)
    8000082e:	00157793          	andi	a5,a0,1
    80000832:	dfdd                	beqz	a5,800007f0 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000834:	3ff57793          	andi	a5,a0,1023
    80000838:	fd7784e3          	beq	a5,s7,80000800 <uvmunmap+0x76>
    if(do_free){
    8000083c:	fc0a8ae3          	beqz	s5,80000810 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000840:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000842:	0532                	slli	a0,a0,0xc
    80000844:	fffff097          	auipc	ra,0xfffff
    80000848:	7d8080e7          	jalr	2008(ra) # 8000001c <kfree>
    8000084c:	b7d1                	j	80000810 <uvmunmap+0x86>

000000008000084e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000084e:	1101                	addi	sp,sp,-32
    80000850:	ec06                	sd	ra,24(sp)
    80000852:	e822                	sd	s0,16(sp)
    80000854:	e426                	sd	s1,8(sp)
    80000856:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000858:	00000097          	auipc	ra,0x0
    8000085c:	906080e7          	jalr	-1786(ra) # 8000015e <kalloc>
    80000860:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000862:	c519                	beqz	a0,80000870 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000864:	6605                	lui	a2,0x1
    80000866:	4581                	li	a1,0
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	990080e7          	jalr	-1648(ra) # 800001f8 <memset>
  return pagetable;
}
    80000870:	8526                	mv	a0,s1
    80000872:	60e2                	ld	ra,24(sp)
    80000874:	6442                	ld	s0,16(sp)
    80000876:	64a2                	ld	s1,8(sp)
    80000878:	6105                	addi	sp,sp,32
    8000087a:	8082                	ret

000000008000087c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000087c:	7179                	addi	sp,sp,-48
    8000087e:	f406                	sd	ra,40(sp)
    80000880:	f022                	sd	s0,32(sp)
    80000882:	ec26                	sd	s1,24(sp)
    80000884:	e84a                	sd	s2,16(sp)
    80000886:	e44e                	sd	s3,8(sp)
    80000888:	e052                	sd	s4,0(sp)
    8000088a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000088c:	6785                	lui	a5,0x1
    8000088e:	04f67863          	bgeu	a2,a5,800008de <uvmfirst+0x62>
    80000892:	8a2a                	mv	s4,a0
    80000894:	89ae                	mv	s3,a1
    80000896:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000898:	00000097          	auipc	ra,0x0
    8000089c:	8c6080e7          	jalr	-1850(ra) # 8000015e <kalloc>
    800008a0:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008a2:	6605                	lui	a2,0x1
    800008a4:	4581                	li	a1,0
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	952080e7          	jalr	-1710(ra) # 800001f8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008ae:	4779                	li	a4,30
    800008b0:	86ca                	mv	a3,s2
    800008b2:	6605                	lui	a2,0x1
    800008b4:	4581                	li	a1,0
    800008b6:	8552                	mv	a0,s4
    800008b8:	00000097          	auipc	ra,0x0
    800008bc:	d0c080e7          	jalr	-756(ra) # 800005c4 <mappages>
  memmove(mem, src, sz);
    800008c0:	8626                	mv	a2,s1
    800008c2:	85ce                	mv	a1,s3
    800008c4:	854a                	mv	a0,s2
    800008c6:	00000097          	auipc	ra,0x0
    800008ca:	98e080e7          	jalr	-1650(ra) # 80000254 <memmove>
}
    800008ce:	70a2                	ld	ra,40(sp)
    800008d0:	7402                	ld	s0,32(sp)
    800008d2:	64e2                	ld	s1,24(sp)
    800008d4:	6942                	ld	s2,16(sp)
    800008d6:	69a2                	ld	s3,8(sp)
    800008d8:	6a02                	ld	s4,0(sp)
    800008da:	6145                	addi	sp,sp,48
    800008dc:	8082                	ret
    panic("uvmfirst: more than a page");
    800008de:	00007517          	auipc	a0,0x7
    800008e2:	7fa50513          	addi	a0,a0,2042 # 800080d8 <etext+0xd8>
    800008e6:	00005097          	auipc	ra,0x5
    800008ea:	4b6080e7          	jalr	1206(ra) # 80005d9c <panic>

00000000800008ee <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008ee:	1101                	addi	sp,sp,-32
    800008f0:	ec06                	sd	ra,24(sp)
    800008f2:	e822                	sd	s0,16(sp)
    800008f4:	e426                	sd	s1,8(sp)
    800008f6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008f8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008fa:	00b67d63          	bgeu	a2,a1,80000914 <uvmdealloc+0x26>
    800008fe:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000900:	6785                	lui	a5,0x1
    80000902:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000904:	00f60733          	add	a4,a2,a5
    80000908:	76fd                	lui	a3,0xfffff
    8000090a:	8f75                	and	a4,a4,a3
    8000090c:	97ae                	add	a5,a5,a1
    8000090e:	8ff5                	and	a5,a5,a3
    80000910:	00f76863          	bltu	a4,a5,80000920 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000914:	8526                	mv	a0,s1
    80000916:	60e2                	ld	ra,24(sp)
    80000918:	6442                	ld	s0,16(sp)
    8000091a:	64a2                	ld	s1,8(sp)
    8000091c:	6105                	addi	sp,sp,32
    8000091e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000920:	8f99                	sub	a5,a5,a4
    80000922:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000924:	4685                	li	a3,1
    80000926:	0007861b          	sext.w	a2,a5
    8000092a:	85ba                	mv	a1,a4
    8000092c:	00000097          	auipc	ra,0x0
    80000930:	e5e080e7          	jalr	-418(ra) # 8000078a <uvmunmap>
    80000934:	b7c5                	j	80000914 <uvmdealloc+0x26>

0000000080000936 <uvmalloc>:
  if(newsz < oldsz)
    80000936:	0ab66563          	bltu	a2,a1,800009e0 <uvmalloc+0xaa>
{
    8000093a:	7139                	addi	sp,sp,-64
    8000093c:	fc06                	sd	ra,56(sp)
    8000093e:	f822                	sd	s0,48(sp)
    80000940:	f426                	sd	s1,40(sp)
    80000942:	f04a                	sd	s2,32(sp)
    80000944:	ec4e                	sd	s3,24(sp)
    80000946:	e852                	sd	s4,16(sp)
    80000948:	e456                	sd	s5,8(sp)
    8000094a:	e05a                	sd	s6,0(sp)
    8000094c:	0080                	addi	s0,sp,64
    8000094e:	8aaa                	mv	s5,a0
    80000950:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000952:	6785                	lui	a5,0x1
    80000954:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000956:	95be                	add	a1,a1,a5
    80000958:	77fd                	lui	a5,0xfffff
    8000095a:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095e:	08c9f363          	bgeu	s3,a2,800009e4 <uvmalloc+0xae>
    80000962:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000964:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000968:	fffff097          	auipc	ra,0xfffff
    8000096c:	7f6080e7          	jalr	2038(ra) # 8000015e <kalloc>
    80000970:	84aa                	mv	s1,a0
    if(mem == 0){
    80000972:	c51d                	beqz	a0,800009a0 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000974:	6605                	lui	a2,0x1
    80000976:	4581                	li	a1,0
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	880080e7          	jalr	-1920(ra) # 800001f8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000980:	875a                	mv	a4,s6
    80000982:	86a6                	mv	a3,s1
    80000984:	6605                	lui	a2,0x1
    80000986:	85ca                	mv	a1,s2
    80000988:	8556                	mv	a0,s5
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	c3a080e7          	jalr	-966(ra) # 800005c4 <mappages>
    80000992:	e90d                	bnez	a0,800009c4 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000994:	6785                	lui	a5,0x1
    80000996:	993e                	add	s2,s2,a5
    80000998:	fd4968e3          	bltu	s2,s4,80000968 <uvmalloc+0x32>
  return newsz;
    8000099c:	8552                	mv	a0,s4
    8000099e:	a809                	j	800009b0 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    800009a0:	864e                	mv	a2,s3
    800009a2:	85ca                	mv	a1,s2
    800009a4:	8556                	mv	a0,s5
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	f48080e7          	jalr	-184(ra) # 800008ee <uvmdealloc>
      return 0;
    800009ae:	4501                	li	a0,0
}
    800009b0:	70e2                	ld	ra,56(sp)
    800009b2:	7442                	ld	s0,48(sp)
    800009b4:	74a2                	ld	s1,40(sp)
    800009b6:	7902                	ld	s2,32(sp)
    800009b8:	69e2                	ld	s3,24(sp)
    800009ba:	6a42                	ld	s4,16(sp)
    800009bc:	6aa2                	ld	s5,8(sp)
    800009be:	6b02                	ld	s6,0(sp)
    800009c0:	6121                	addi	sp,sp,64
    800009c2:	8082                	ret
      kfree(mem);
    800009c4:	8526                	mv	a0,s1
    800009c6:	fffff097          	auipc	ra,0xfffff
    800009ca:	656080e7          	jalr	1622(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009ce:	864e                	mv	a2,s3
    800009d0:	85ca                	mv	a1,s2
    800009d2:	8556                	mv	a0,s5
    800009d4:	00000097          	auipc	ra,0x0
    800009d8:	f1a080e7          	jalr	-230(ra) # 800008ee <uvmdealloc>
      return 0;
    800009dc:	4501                	li	a0,0
    800009de:	bfc9                	j	800009b0 <uvmalloc+0x7a>
    return oldsz;
    800009e0:	852e                	mv	a0,a1
}
    800009e2:	8082                	ret
  return newsz;
    800009e4:	8532                	mv	a0,a2
    800009e6:	b7e9                	j	800009b0 <uvmalloc+0x7a>

00000000800009e8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009e8:	7179                	addi	sp,sp,-48
    800009ea:	f406                	sd	ra,40(sp)
    800009ec:	f022                	sd	s0,32(sp)
    800009ee:	ec26                	sd	s1,24(sp)
    800009f0:	e84a                	sd	s2,16(sp)
    800009f2:	e44e                	sd	s3,8(sp)
    800009f4:	e052                	sd	s4,0(sp)
    800009f6:	1800                	addi	s0,sp,48
    800009f8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009fa:	84aa                	mv	s1,a0
    800009fc:	6905                	lui	s2,0x1
    800009fe:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a00:	4985                	li	s3,1
    80000a02:	a829                	j	80000a1c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a04:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a06:	00c79513          	slli	a0,a5,0xc
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	fde080e7          	jalr	-34(ra) # 800009e8 <freewalk>
      pagetable[i] = 0;
    80000a12:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a16:	04a1                	addi	s1,s1,8
    80000a18:	03248163          	beq	s1,s2,80000a3a <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a1c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a1e:	00f7f713          	andi	a4,a5,15
    80000a22:	ff3701e3          	beq	a4,s3,80000a04 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a26:	8b85                	andi	a5,a5,1
    80000a28:	d7fd                	beqz	a5,80000a16 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a2a:	00007517          	auipc	a0,0x7
    80000a2e:	6ce50513          	addi	a0,a0,1742 # 800080f8 <etext+0xf8>
    80000a32:	00005097          	auipc	ra,0x5
    80000a36:	36a080e7          	jalr	874(ra) # 80005d9c <panic>
    }
  }
  kfree((void*)pagetable);
    80000a3a:	8552                	mv	a0,s4
    80000a3c:	fffff097          	auipc	ra,0xfffff
    80000a40:	5e0080e7          	jalr	1504(ra) # 8000001c <kfree>
}
    80000a44:	70a2                	ld	ra,40(sp)
    80000a46:	7402                	ld	s0,32(sp)
    80000a48:	64e2                	ld	s1,24(sp)
    80000a4a:	6942                	ld	s2,16(sp)
    80000a4c:	69a2                	ld	s3,8(sp)
    80000a4e:	6a02                	ld	s4,0(sp)
    80000a50:	6145                	addi	sp,sp,48
    80000a52:	8082                	ret

0000000080000a54 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a54:	1101                	addi	sp,sp,-32
    80000a56:	ec06                	sd	ra,24(sp)
    80000a58:	e822                	sd	s0,16(sp)
    80000a5a:	e426                	sd	s1,8(sp)
    80000a5c:	1000                	addi	s0,sp,32
    80000a5e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a60:	e999                	bnez	a1,80000a76 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a62:	8526                	mv	a0,s1
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	f84080e7          	jalr	-124(ra) # 800009e8 <freewalk>
}
    80000a6c:	60e2                	ld	ra,24(sp)
    80000a6e:	6442                	ld	s0,16(sp)
    80000a70:	64a2                	ld	s1,8(sp)
    80000a72:	6105                	addi	sp,sp,32
    80000a74:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a76:	6785                	lui	a5,0x1
    80000a78:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a7a:	95be                	add	a1,a1,a5
    80000a7c:	4685                	li	a3,1
    80000a7e:	00c5d613          	srli	a2,a1,0xc
    80000a82:	4581                	li	a1,0
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	d06080e7          	jalr	-762(ra) # 8000078a <uvmunmap>
    80000a8c:	bfd9                	j	80000a62 <uvmfree+0xe>

0000000080000a8e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a8e:	ca75                	beqz	a2,80000b82 <uvmcopy+0xf4>
{
    80000a90:	715d                	addi	sp,sp,-80
    80000a92:	e486                	sd	ra,72(sp)
    80000a94:	e0a2                	sd	s0,64(sp)
    80000a96:	fc26                	sd	s1,56(sp)
    80000a98:	f84a                	sd	s2,48(sp)
    80000a9a:	f44e                	sd	s3,40(sp)
    80000a9c:	f052                	sd	s4,32(sp)
    80000a9e:	ec56                	sd	s5,24(sp)
    80000aa0:	e85a                	sd	s6,16(sp)
    80000aa2:	e45e                	sd	s7,8(sp)
    80000aa4:	e062                	sd	s8,0(sp)
    80000aa6:	0880                	addi	s0,sp,80
    80000aa8:	8baa                	mv	s7,a0
    80000aaa:	8b2e                	mv	s6,a1
    80000aac:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000aae:	4981                	li	s3,0
      *pte |= PTE_RSW;
    }
    pa = PTE2PA(*pte);

    // increment the ref count
    acquire(&ref_count_lock);
    80000ab0:	00008a17          	auipc	s4,0x8
    80000ab4:	e30a0a13          	addi	s4,s4,-464 # 800088e0 <ref_count_lock>
    useReference[pa/PGSIZE] += 1;
    80000ab8:	00008c17          	auipc	s8,0x8
    80000abc:	e60c0c13          	addi	s8,s8,-416 # 80008918 <useReference>
    80000ac0:	a0b5                	j	80000b2c <uvmcopy+0x9e>
      panic("uvmcopy: pte should exist");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	64650513          	addi	a0,a0,1606 # 80008108 <etext+0x108>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	2d2080e7          	jalr	722(ra) # 80005d9c <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	65650513          	addi	a0,a0,1622 # 80008128 <etext+0x128>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	2c2080e7          	jalr	706(ra) # 80005d9c <panic>
    pa = PTE2PA(*pte);
    80000ae2:	0004b903          	ld	s2,0(s1)
    80000ae6:	00a95913          	srli	s2,s2,0xa
    80000aea:	0932                	slli	s2,s2,0xc
    acquire(&ref_count_lock);
    80000aec:	8552                	mv	a0,s4
    80000aee:	00005097          	auipc	ra,0x5
    80000af2:	7e6080e7          	jalr	2022(ra) # 800062d4 <acquire>
    useReference[pa/PGSIZE] += 1;
    80000af6:	00a95793          	srli	a5,s2,0xa
    80000afa:	97e2                	add	a5,a5,s8
    80000afc:	4398                	lw	a4,0(a5)
    80000afe:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdbd291>
    80000b00:	c398                	sw	a4,0(a5)
    release(&ref_count_lock);
    80000b02:	8552                	mv	a0,s4
    80000b04:	00006097          	auipc	ra,0x6
    80000b08:	884080e7          	jalr	-1916(ra) # 80006388 <release>

    flags = PTE_FLAGS(*pte);
    80000b0c:	6098                	ld	a4,0(s1)
    // if((mem = kalloc()) == 0)
    //   goto err;
    // memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000b0e:	3ff77713          	andi	a4,a4,1023
    80000b12:	86ca                	mv	a3,s2
    80000b14:	6605                	lui	a2,0x1
    80000b16:	85ce                	mv	a1,s3
    80000b18:	855a                	mv	a0,s6
    80000b1a:	00000097          	auipc	ra,0x0
    80000b1e:	aaa080e7          	jalr	-1366(ra) # 800005c4 <mappages>
    80000b22:	e915                	bnez	a0,80000b56 <uvmcopy+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
    80000b24:	6785                	lui	a5,0x1
    80000b26:	99be                	add	s3,s3,a5
    80000b28:	0559f163          	bgeu	s3,s5,80000b6a <uvmcopy+0xdc>
    if((pte = walk(old, i, 0)) == 0)
    80000b2c:	4601                	li	a2,0
    80000b2e:	85ce                	mv	a1,s3
    80000b30:	855e                	mv	a0,s7
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	9aa080e7          	jalr	-1622(ra) # 800004dc <walk>
    80000b3a:	84aa                	mv	s1,a0
    80000b3c:	d159                	beqz	a0,80000ac2 <uvmcopy+0x34>
    if((*pte & PTE_V) == 0)
    80000b3e:	611c                	ld	a5,0(a0)
    80000b40:	0017f713          	andi	a4,a5,1
    80000b44:	d759                	beqz	a4,80000ad2 <uvmcopy+0x44>
    if (*pte & PTE_W) {
    80000b46:	0047f713          	andi	a4,a5,4
    80000b4a:	df41                	beqz	a4,80000ae2 <uvmcopy+0x54>
      *pte &= ~PTE_W;
    80000b4c:	9bed                	andi	a5,a5,-5
      *pte |= PTE_RSW;
    80000b4e:	1007e793          	ori	a5,a5,256
    80000b52:	e11c                	sd	a5,0(a0)
    80000b54:	b779                	j	80000ae2 <uvmcopy+0x54>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b56:	4685                	li	a3,1
    80000b58:	00c9d613          	srli	a2,s3,0xc
    80000b5c:	4581                	li	a1,0
    80000b5e:	855a                	mv	a0,s6
    80000b60:	00000097          	auipc	ra,0x0
    80000b64:	c2a080e7          	jalr	-982(ra) # 8000078a <uvmunmap>
  return -1;
    80000b68:	557d                	li	a0,-1
}
    80000b6a:	60a6                	ld	ra,72(sp)
    80000b6c:	6406                	ld	s0,64(sp)
    80000b6e:	74e2                	ld	s1,56(sp)
    80000b70:	7942                	ld	s2,48(sp)
    80000b72:	79a2                	ld	s3,40(sp)
    80000b74:	7a02                	ld	s4,32(sp)
    80000b76:	6ae2                	ld	s5,24(sp)
    80000b78:	6b42                	ld	s6,16(sp)
    80000b7a:	6ba2                	ld	s7,8(sp)
    80000b7c:	6c02                	ld	s8,0(sp)
    80000b7e:	6161                	addi	sp,sp,80
    80000b80:	8082                	ret
  return 0;
    80000b82:	4501                	li	a0,0
}
    80000b84:	8082                	ret

0000000080000b86 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b86:	1141                	addi	sp,sp,-16
    80000b88:	e406                	sd	ra,8(sp)
    80000b8a:	e022                	sd	s0,0(sp)
    80000b8c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b8e:	4601                	li	a2,0
    80000b90:	00000097          	auipc	ra,0x0
    80000b94:	94c080e7          	jalr	-1716(ra) # 800004dc <walk>
  if(pte == 0)
    80000b98:	c901                	beqz	a0,80000ba8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b9a:	611c                	ld	a5,0(a0)
    80000b9c:	9bbd                	andi	a5,a5,-17
    80000b9e:	e11c                	sd	a5,0(a0)
}
    80000ba0:	60a2                	ld	ra,8(sp)
    80000ba2:	6402                	ld	s0,0(sp)
    80000ba4:	0141                	addi	sp,sp,16
    80000ba6:	8082                	ret
    panic("uvmclear");
    80000ba8:	00007517          	auipc	a0,0x7
    80000bac:	5a050513          	addi	a0,a0,1440 # 80008148 <etext+0x148>
    80000bb0:	00005097          	auipc	ra,0x5
    80000bb4:	1ec080e7          	jalr	492(ra) # 80005d9c <panic>

0000000080000bb8 <checkcowpage>:

int checkcowpage(uint64 va, pte_t *pte, struct proc* p) {
    80000bb8:	1141                	addi	sp,sp,-16
    80000bba:	e422                	sd	s0,8(sp)
    80000bbc:	0800                	addi	s0,sp,16
  return (va < p->sz) // va should blow the size of process memory (bytes)
    && (*pte & PTE_V) 
    && (*pte & PTE_RSW); // pte is COW page
    80000bbe:	663c                	ld	a5,72(a2)
    80000bc0:	00f57c63          	bgeu	a0,a5,80000bd8 <checkcowpage+0x20>
    80000bc4:	6188                	ld	a0,0(a1)
    80000bc6:	10157513          	andi	a0,a0,257
    80000bca:	eff50513          	addi	a0,a0,-257
    80000bce:	00153513          	seqz	a0,a0
}
    80000bd2:	6422                	ld	s0,8(sp)
    80000bd4:	0141                	addi	sp,sp,16
    80000bd6:	8082                	ret
    && (*pte & PTE_RSW); // pte is COW page
    80000bd8:	4501                	li	a0,0
    80000bda:	bfe5                	j	80000bd2 <checkcowpage+0x1a>

0000000080000bdc <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bdc:	ceed                	beqz	a3,80000cd6 <copyout+0xfa>
{
    80000bde:	7159                	addi	sp,sp,-112
    80000be0:	f486                	sd	ra,104(sp)
    80000be2:	f0a2                	sd	s0,96(sp)
    80000be4:	eca6                	sd	s1,88(sp)
    80000be6:	e8ca                	sd	s2,80(sp)
    80000be8:	e4ce                	sd	s3,72(sp)
    80000bea:	e0d2                	sd	s4,64(sp)
    80000bec:	fc56                	sd	s5,56(sp)
    80000bee:	f85a                	sd	s6,48(sp)
    80000bf0:	f45e                	sd	s7,40(sp)
    80000bf2:	f062                	sd	s8,32(sp)
    80000bf4:	ec66                	sd	s9,24(sp)
    80000bf6:	e86a                	sd	s10,16(sp)
    80000bf8:	e46e                	sd	s11,8(sp)
    80000bfa:	1880                	addi	s0,sp,112
    80000bfc:	8baa                	mv	s7,a0
    80000bfe:	84ae                	mv	s1,a1
    80000c00:	8b32                	mv	s6,a2
    80000c02:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000c04:	7c7d                	lui	s8,0xfffff
      return -1;

    struct proc *p = myproc();
    pte_t *pte = walk(pagetable, va0, 0);
    if (*pte == 0)
      p->killed = 1;
    80000c06:	4c85                	li	s9,1
    80000c08:	a895                	j	80000c7c <copyout+0xa0>
    // check
    if (checkcowpage(va0, pte, p)) 
    {
      char *mem;
      if ((mem = kalloc()) == 0) {
    80000c0a:	fffff097          	auipc	ra,0xfffff
    80000c0e:	554080e7          	jalr	1364(ra) # 8000015e <kalloc>
    80000c12:	8daa                	mv	s11,a0
    80000c14:	c121                	beqz	a0,80000c54 <copyout+0x78>
        // kill the process
        p->killed = 1;
      }else {
        memmove(mem, (char*)pa0, PGSIZE);
    80000c16:	6605                	lui	a2,0x1
    80000c18:	85d2                	mv	a1,s4
    80000c1a:	fffff097          	auipc	ra,0xfffff
    80000c1e:	63a080e7          	jalr	1594(ra) # 80000254 <memmove>
        // PAY ATTENTION!!!
        // This statement must be above the next statement
        uint flags = PTE_FLAGS(*pte);
    80000c22:	00093d03          	ld	s10,0(s2) # 1000 <_entry-0x7ffff000>
    80000c26:	3ffd7d13          	andi	s10,s10,1023
        // decrease the reference count of old memory that va0 point
        // and set pte to 0
        uvmunmap(pagetable, va0, 1, 1);
    80000c2a:	86e6                	mv	a3,s9
    80000c2c:	8666                	mv	a2,s9
    80000c2e:	85ce                	mv	a1,s3
    80000c30:	855e                	mv	a0,s7
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	b58080e7          	jalr	-1192(ra) # 8000078a <uvmunmap>
        // change the physical memory address and set PTE_W to 1
        *pte = (PA2PTE(mem) | flags | PTE_W);
    80000c3a:	8a6e                	mv	s4,s11
    80000c3c:	00cddd93          	srli	s11,s11,0xc
    80000c40:	0daa                	slli	s11,s11,0xa
    80000c42:	01bd6d33          	or	s10,s10,s11
        // set PTE_RSW to 0
        *pte &= ~PTE_RSW;
    80000c46:	effd7d13          	andi	s10,s10,-257
    80000c4a:	004d6d13          	ori	s10,s10,4
    80000c4e:	01a93023          	sd	s10,0(s2)
        // update pa0 to new physical memory address
        pa0 = (uint64)mem;
    80000c52:	a885                	j	80000cc2 <copyout+0xe6>
        p->killed = 1;
    80000c54:	039d2423          	sw	s9,40(s10)
    80000c58:	a0ad                	j	80000cc2 <copyout+0xe6>
    }
    
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c5a:	41348533          	sub	a0,s1,s3
    80000c5e:	0009061b          	sext.w	a2,s2
    80000c62:	85da                	mv	a1,s6
    80000c64:	9552                	add	a0,a0,s4
    80000c66:	fffff097          	auipc	ra,0xfffff
    80000c6a:	5ee080e7          	jalr	1518(ra) # 80000254 <memmove>

    len -= n;
    80000c6e:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000c72:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000c74:	6485                	lui	s1,0x1
    80000c76:	94ce                	add	s1,s1,s3
  while(len > 0){
    80000c78:	040a8d63          	beqz	s5,80000cd2 <copyout+0xf6>
    va0 = PGROUNDDOWN(dstva);
    80000c7c:	0184f9b3          	and	s3,s1,s8
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85ce                	mv	a1,s3
    80000c82:	855e                	mv	a0,s7
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	8fe080e7          	jalr	-1794(ra) # 80000582 <walkaddr>
    80000c8c:	8a2a                	mv	s4,a0
    if(pa0 == 0)
    80000c8e:	c531                	beqz	a0,80000cda <copyout+0xfe>
    struct proc *p = myproc();
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	31a080e7          	jalr	794(ra) # 80000faa <myproc>
    80000c98:	8d2a                	mv	s10,a0
    pte_t *pte = walk(pagetable, va0, 0);
    80000c9a:	4601                	li	a2,0
    80000c9c:	85ce                	mv	a1,s3
    80000c9e:	855e                	mv	a0,s7
    80000ca0:	00000097          	auipc	ra,0x0
    80000ca4:	83c080e7          	jalr	-1988(ra) # 800004dc <walk>
    80000ca8:	892a                	mv	s2,a0
    if (*pte == 0)
    80000caa:	611c                	ld	a5,0(a0)
    80000cac:	e399                	bnez	a5,80000cb2 <copyout+0xd6>
      p->killed = 1;
    80000cae:	039d2423          	sw	s9,40(s10)
    if (checkcowpage(va0, pte, p)) 
    80000cb2:	866a                	mv	a2,s10
    80000cb4:	85ca                	mv	a1,s2
    80000cb6:	854e                	mv	a0,s3
    80000cb8:	00000097          	auipc	ra,0x0
    80000cbc:	f00080e7          	jalr	-256(ra) # 80000bb8 <checkcowpage>
    80000cc0:	f529                	bnez	a0,80000c0a <copyout+0x2e>
    n = PGSIZE - (dstva - va0);
    80000cc2:	40998933          	sub	s2,s3,s1
    80000cc6:	6785                	lui	a5,0x1
    80000cc8:	993e                	add	s2,s2,a5
    80000cca:	f92af8e3          	bgeu	s5,s2,80000c5a <copyout+0x7e>
    80000cce:	8956                	mv	s2,s5
    80000cd0:	b769                	j	80000c5a <copyout+0x7e>
  }
  return 0;
    80000cd2:	4501                	li	a0,0
    80000cd4:	a021                	j	80000cdc <copyout+0x100>
    80000cd6:	4501                	li	a0,0
}
    80000cd8:	8082                	ret
      return -1;
    80000cda:	557d                	li	a0,-1
}
    80000cdc:	70a6                	ld	ra,104(sp)
    80000cde:	7406                	ld	s0,96(sp)
    80000ce0:	64e6                	ld	s1,88(sp)
    80000ce2:	6946                	ld	s2,80(sp)
    80000ce4:	69a6                	ld	s3,72(sp)
    80000ce6:	6a06                	ld	s4,64(sp)
    80000ce8:	7ae2                	ld	s5,56(sp)
    80000cea:	7b42                	ld	s6,48(sp)
    80000cec:	7ba2                	ld	s7,40(sp)
    80000cee:	7c02                	ld	s8,32(sp)
    80000cf0:	6ce2                	ld	s9,24(sp)
    80000cf2:	6d42                	ld	s10,16(sp)
    80000cf4:	6da2                	ld	s11,8(sp)
    80000cf6:	6165                	addi	sp,sp,112
    80000cf8:	8082                	ret

0000000080000cfa <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cfa:	caa5                	beqz	a3,80000d6a <copyin+0x70>
{
    80000cfc:	715d                	addi	sp,sp,-80
    80000cfe:	e486                	sd	ra,72(sp)
    80000d00:	e0a2                	sd	s0,64(sp)
    80000d02:	fc26                	sd	s1,56(sp)
    80000d04:	f84a                	sd	s2,48(sp)
    80000d06:	f44e                	sd	s3,40(sp)
    80000d08:	f052                	sd	s4,32(sp)
    80000d0a:	ec56                	sd	s5,24(sp)
    80000d0c:	e85a                	sd	s6,16(sp)
    80000d0e:	e45e                	sd	s7,8(sp)
    80000d10:	e062                	sd	s8,0(sp)
    80000d12:	0880                	addi	s0,sp,80
    80000d14:	8b2a                	mv	s6,a0
    80000d16:	8a2e                	mv	s4,a1
    80000d18:	8c32                	mv	s8,a2
    80000d1a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d1c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d1e:	6a85                	lui	s5,0x1
    80000d20:	a01d                	j	80000d46 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d22:	018505b3          	add	a1,a0,s8
    80000d26:	0004861b          	sext.w	a2,s1
    80000d2a:	412585b3          	sub	a1,a1,s2
    80000d2e:	8552                	mv	a0,s4
    80000d30:	fffff097          	auipc	ra,0xfffff
    80000d34:	524080e7          	jalr	1316(ra) # 80000254 <memmove>

    len -= n;
    80000d38:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d3c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d3e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d42:	02098263          	beqz	s3,80000d66 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d46:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d4a:	85ca                	mv	a1,s2
    80000d4c:	855a                	mv	a0,s6
    80000d4e:	00000097          	auipc	ra,0x0
    80000d52:	834080e7          	jalr	-1996(ra) # 80000582 <walkaddr>
    if(pa0 == 0)
    80000d56:	cd01                	beqz	a0,80000d6e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d58:	418904b3          	sub	s1,s2,s8
    80000d5c:	94d6                	add	s1,s1,s5
    80000d5e:	fc99f2e3          	bgeu	s3,s1,80000d22 <copyin+0x28>
    80000d62:	84ce                	mv	s1,s3
    80000d64:	bf7d                	j	80000d22 <copyin+0x28>
  }
  return 0;
    80000d66:	4501                	li	a0,0
    80000d68:	a021                	j	80000d70 <copyin+0x76>
    80000d6a:	4501                	li	a0,0
}
    80000d6c:	8082                	ret
      return -1;
    80000d6e:	557d                	li	a0,-1
}
    80000d70:	60a6                	ld	ra,72(sp)
    80000d72:	6406                	ld	s0,64(sp)
    80000d74:	74e2                	ld	s1,56(sp)
    80000d76:	7942                	ld	s2,48(sp)
    80000d78:	79a2                	ld	s3,40(sp)
    80000d7a:	7a02                	ld	s4,32(sp)
    80000d7c:	6ae2                	ld	s5,24(sp)
    80000d7e:	6b42                	ld	s6,16(sp)
    80000d80:	6ba2                	ld	s7,8(sp)
    80000d82:	6c02                	ld	s8,0(sp)
    80000d84:	6161                	addi	sp,sp,80
    80000d86:	8082                	ret

0000000080000d88 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d88:	c2dd                	beqz	a3,80000e2e <copyinstr+0xa6>
{
    80000d8a:	715d                	addi	sp,sp,-80
    80000d8c:	e486                	sd	ra,72(sp)
    80000d8e:	e0a2                	sd	s0,64(sp)
    80000d90:	fc26                	sd	s1,56(sp)
    80000d92:	f84a                	sd	s2,48(sp)
    80000d94:	f44e                	sd	s3,40(sp)
    80000d96:	f052                	sd	s4,32(sp)
    80000d98:	ec56                	sd	s5,24(sp)
    80000d9a:	e85a                	sd	s6,16(sp)
    80000d9c:	e45e                	sd	s7,8(sp)
    80000d9e:	0880                	addi	s0,sp,80
    80000da0:	8a2a                	mv	s4,a0
    80000da2:	8b2e                	mv	s6,a1
    80000da4:	8bb2                	mv	s7,a2
    80000da6:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000da8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000daa:	6985                	lui	s3,0x1
    80000dac:	a02d                	j	80000dd6 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000dae:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000db2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000db4:	37fd                	addiw	a5,a5,-1
    80000db6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
    80000dba:	60a6                	ld	ra,72(sp)
    80000dbc:	6406                	ld	s0,64(sp)
    80000dbe:	74e2                	ld	s1,56(sp)
    80000dc0:	7942                	ld	s2,48(sp)
    80000dc2:	79a2                	ld	s3,40(sp)
    80000dc4:	7a02                	ld	s4,32(sp)
    80000dc6:	6ae2                	ld	s5,24(sp)
    80000dc8:	6b42                	ld	s6,16(sp)
    80000dca:	6ba2                	ld	s7,8(sp)
    80000dcc:	6161                	addi	sp,sp,80
    80000dce:	8082                	ret
    srcva = va0 + PGSIZE;
    80000dd0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000dd4:	c8a9                	beqz	s1,80000e26 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000dd6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000dda:	85ca                	mv	a1,s2
    80000ddc:	8552                	mv	a0,s4
    80000dde:	fffff097          	auipc	ra,0xfffff
    80000de2:	7a4080e7          	jalr	1956(ra) # 80000582 <walkaddr>
    if(pa0 == 0)
    80000de6:	c131                	beqz	a0,80000e2a <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000de8:	417906b3          	sub	a3,s2,s7
    80000dec:	96ce                	add	a3,a3,s3
    80000dee:	00d4f363          	bgeu	s1,a3,80000df4 <copyinstr+0x6c>
    80000df2:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000df4:	955e                	add	a0,a0,s7
    80000df6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000dfa:	daf9                	beqz	a3,80000dd0 <copyinstr+0x48>
    80000dfc:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000dfe:	41650633          	sub	a2,a0,s6
    80000e02:	fff48593          	addi	a1,s1,-1 # fff <_entry-0x7ffff001>
    80000e06:	95da                	add	a1,a1,s6
    while(n > 0){
    80000e08:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000e0a:	00f60733          	add	a4,a2,a5
    80000e0e:	00074703          	lbu	a4,0(a4)
    80000e12:	df51                	beqz	a4,80000dae <copyinstr+0x26>
        *dst = *p;
    80000e14:	00e78023          	sb	a4,0(a5)
      --max;
    80000e18:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000e1c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e1e:	fed796e3          	bne	a5,a3,80000e0a <copyinstr+0x82>
      dst++;
    80000e22:	8b3e                	mv	s6,a5
    80000e24:	b775                	j	80000dd0 <copyinstr+0x48>
    80000e26:	4781                	li	a5,0
    80000e28:	b771                	j	80000db4 <copyinstr+0x2c>
      return -1;
    80000e2a:	557d                	li	a0,-1
    80000e2c:	b779                	j	80000dba <copyinstr+0x32>
  int got_null = 0;
    80000e2e:	4781                	li	a5,0
  if(got_null){
    80000e30:	37fd                	addiw	a5,a5,-1
    80000e32:	0007851b          	sext.w	a0,a5
    80000e36:	8082                	ret

0000000080000e38 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000e38:	7139                	addi	sp,sp,-64
    80000e3a:	fc06                	sd	ra,56(sp)
    80000e3c:	f822                	sd	s0,48(sp)
    80000e3e:	f426                	sd	s1,40(sp)
    80000e40:	f04a                	sd	s2,32(sp)
    80000e42:	ec4e                	sd	s3,24(sp)
    80000e44:	e852                	sd	s4,16(sp)
    80000e46:	e456                	sd	s5,8(sp)
    80000e48:	e05a                	sd	s6,0(sp)
    80000e4a:	0080                	addi	s0,sp,64
    80000e4c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4e:	00228497          	auipc	s1,0x228
    80000e52:	efa48493          	addi	s1,s1,-262 # 80228d48 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e56:	8b26                	mv	s6,s1
    80000e58:	00007a97          	auipc	s5,0x7
    80000e5c:	1a8a8a93          	addi	s5,s5,424 # 80008000 <etext>
    80000e60:	01000937          	lui	s2,0x1000
    80000e64:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e66:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e68:	0022ea17          	auipc	s4,0x22e
    80000e6c:	8e0a0a13          	addi	s4,s4,-1824 # 8022e748 <tickslock>
    char *pa = kalloc();
    80000e70:	fffff097          	auipc	ra,0xfffff
    80000e74:	2ee080e7          	jalr	750(ra) # 8000015e <kalloc>
    80000e78:	862a                	mv	a2,a0
    if(pa == 0)
    80000e7a:	c129                	beqz	a0,80000ebc <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e7c:	416485b3          	sub	a1,s1,s6
    80000e80:	858d                	srai	a1,a1,0x3
    80000e82:	000ab783          	ld	a5,0(s5)
    80000e86:	02f585b3          	mul	a1,a1,a5
    80000e8a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e8e:	4719                	li	a4,6
    80000e90:	6685                	lui	a3,0x1
    80000e92:	40b905b3          	sub	a1,s2,a1
    80000e96:	854e                	mv	a0,s3
    80000e98:	fffff097          	auipc	ra,0xfffff
    80000e9c:	7cc080e7          	jalr	1996(ra) # 80000664 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea0:	16848493          	addi	s1,s1,360
    80000ea4:	fd4496e3          	bne	s1,s4,80000e70 <proc_mapstacks+0x38>
  }
}
    80000ea8:	70e2                	ld	ra,56(sp)
    80000eaa:	7442                	ld	s0,48(sp)
    80000eac:	74a2                	ld	s1,40(sp)
    80000eae:	7902                	ld	s2,32(sp)
    80000eb0:	69e2                	ld	s3,24(sp)
    80000eb2:	6a42                	ld	s4,16(sp)
    80000eb4:	6aa2                	ld	s5,8(sp)
    80000eb6:	6b02                	ld	s6,0(sp)
    80000eb8:	6121                	addi	sp,sp,64
    80000eba:	8082                	ret
      panic("kalloc");
    80000ebc:	00007517          	auipc	a0,0x7
    80000ec0:	29c50513          	addi	a0,a0,668 # 80008158 <etext+0x158>
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	ed8080e7          	jalr	-296(ra) # 80005d9c <panic>

0000000080000ecc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000ecc:	7139                	addi	sp,sp,-64
    80000ece:	fc06                	sd	ra,56(sp)
    80000ed0:	f822                	sd	s0,48(sp)
    80000ed2:	f426                	sd	s1,40(sp)
    80000ed4:	f04a                	sd	s2,32(sp)
    80000ed6:	ec4e                	sd	s3,24(sp)
    80000ed8:	e852                	sd	s4,16(sp)
    80000eda:	e456                	sd	s5,8(sp)
    80000edc:	e05a                	sd	s6,0(sp)
    80000ede:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ee0:	00007597          	auipc	a1,0x7
    80000ee4:	28058593          	addi	a1,a1,640 # 80008160 <etext+0x160>
    80000ee8:	00228517          	auipc	a0,0x228
    80000eec:	a3050513          	addi	a0,a0,-1488 # 80228918 <pid_lock>
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	354080e7          	jalr	852(ra) # 80006244 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ef8:	00007597          	auipc	a1,0x7
    80000efc:	27058593          	addi	a1,a1,624 # 80008168 <etext+0x168>
    80000f00:	00228517          	auipc	a0,0x228
    80000f04:	a3050513          	addi	a0,a0,-1488 # 80228930 <wait_lock>
    80000f08:	00005097          	auipc	ra,0x5
    80000f0c:	33c080e7          	jalr	828(ra) # 80006244 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f10:	00228497          	auipc	s1,0x228
    80000f14:	e3848493          	addi	s1,s1,-456 # 80228d48 <proc>
      initlock(&p->lock, "proc");
    80000f18:	00007b17          	auipc	s6,0x7
    80000f1c:	260b0b13          	addi	s6,s6,608 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000f20:	8aa6                	mv	s5,s1
    80000f22:	00007a17          	auipc	s4,0x7
    80000f26:	0dea0a13          	addi	s4,s4,222 # 80008000 <etext>
    80000f2a:	01000937          	lui	s2,0x1000
    80000f2e:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000f30:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f32:	0022e997          	auipc	s3,0x22e
    80000f36:	81698993          	addi	s3,s3,-2026 # 8022e748 <tickslock>
      initlock(&p->lock, "proc");
    80000f3a:	85da                	mv	a1,s6
    80000f3c:	8526                	mv	a0,s1
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	306080e7          	jalr	774(ra) # 80006244 <initlock>
      p->state = UNUSED;
    80000f46:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000f4a:	415487b3          	sub	a5,s1,s5
    80000f4e:	878d                	srai	a5,a5,0x3
    80000f50:	000a3703          	ld	a4,0(s4)
    80000f54:	02e787b3          	mul	a5,a5,a4
    80000f58:	00d7979b          	slliw	a5,a5,0xd
    80000f5c:	40f907b3          	sub	a5,s2,a5
    80000f60:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f62:	16848493          	addi	s1,s1,360
    80000f66:	fd349ae3          	bne	s1,s3,80000f3a <procinit+0x6e>
  }
}
    80000f6a:	70e2                	ld	ra,56(sp)
    80000f6c:	7442                	ld	s0,48(sp)
    80000f6e:	74a2                	ld	s1,40(sp)
    80000f70:	7902                	ld	s2,32(sp)
    80000f72:	69e2                	ld	s3,24(sp)
    80000f74:	6a42                	ld	s4,16(sp)
    80000f76:	6aa2                	ld	s5,8(sp)
    80000f78:	6b02                	ld	s6,0(sp)
    80000f7a:	6121                	addi	sp,sp,64
    80000f7c:	8082                	ret

0000000080000f7e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f7e:	1141                	addi	sp,sp,-16
    80000f80:	e422                	sd	s0,8(sp)
    80000f82:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f84:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f86:	2501                	sext.w	a0,a0
    80000f88:	6422                	ld	s0,8(sp)
    80000f8a:	0141                	addi	sp,sp,16
    80000f8c:	8082                	ret

0000000080000f8e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e422                	sd	s0,8(sp)
    80000f92:	0800                	addi	s0,sp,16
    80000f94:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f96:	2781                	sext.w	a5,a5
    80000f98:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f9a:	00228517          	auipc	a0,0x228
    80000f9e:	9ae50513          	addi	a0,a0,-1618 # 80228948 <cpus>
    80000fa2:	953e                	add	a0,a0,a5
    80000fa4:	6422                	ld	s0,8(sp)
    80000fa6:	0141                	addi	sp,sp,16
    80000fa8:	8082                	ret

0000000080000faa <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000faa:	1101                	addi	sp,sp,-32
    80000fac:	ec06                	sd	ra,24(sp)
    80000fae:	e822                	sd	s0,16(sp)
    80000fb0:	e426                	sd	s1,8(sp)
    80000fb2:	1000                	addi	s0,sp,32
  push_off();
    80000fb4:	00005097          	auipc	ra,0x5
    80000fb8:	2d4080e7          	jalr	724(ra) # 80006288 <push_off>
    80000fbc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fbe:	2781                	sext.w	a5,a5
    80000fc0:	079e                	slli	a5,a5,0x7
    80000fc2:	00228717          	auipc	a4,0x228
    80000fc6:	95670713          	addi	a4,a4,-1706 # 80228918 <pid_lock>
    80000fca:	97ba                	add	a5,a5,a4
    80000fcc:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fce:	00005097          	auipc	ra,0x5
    80000fd2:	35a080e7          	jalr	858(ra) # 80006328 <pop_off>
  return p;
}
    80000fd6:	8526                	mv	a0,s1
    80000fd8:	60e2                	ld	ra,24(sp)
    80000fda:	6442                	ld	s0,16(sp)
    80000fdc:	64a2                	ld	s1,8(sp)
    80000fde:	6105                	addi	sp,sp,32
    80000fe0:	8082                	ret

0000000080000fe2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fea:	00000097          	auipc	ra,0x0
    80000fee:	fc0080e7          	jalr	-64(ra) # 80000faa <myproc>
    80000ff2:	00005097          	auipc	ra,0x5
    80000ff6:	396080e7          	jalr	918(ra) # 80006388 <release>

  if (first) {
    80000ffa:	00008797          	auipc	a5,0x8
    80000ffe:	8467a783          	lw	a5,-1978(a5) # 80008840 <first.1>
    80001002:	eb89                	bnez	a5,80001014 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001004:	00001097          	auipc	ra,0x1
    80001008:	cf0080e7          	jalr	-784(ra) # 80001cf4 <usertrapret>
}
    8000100c:	60a2                	ld	ra,8(sp)
    8000100e:	6402                	ld	s0,0(sp)
    80001010:	0141                	addi	sp,sp,16
    80001012:	8082                	ret
    first = 0;
    80001014:	00008797          	auipc	a5,0x8
    80001018:	8207a623          	sw	zero,-2004(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    8000101c:	4505                	li	a0,1
    8000101e:	00002097          	auipc	ra,0x2
    80001022:	a4c080e7          	jalr	-1460(ra) # 80002a6a <fsinit>
    80001026:	bff9                	j	80001004 <forkret+0x22>

0000000080001028 <allocpid>:
{
    80001028:	1101                	addi	sp,sp,-32
    8000102a:	ec06                	sd	ra,24(sp)
    8000102c:	e822                	sd	s0,16(sp)
    8000102e:	e426                	sd	s1,8(sp)
    80001030:	e04a                	sd	s2,0(sp)
    80001032:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001034:	00228917          	auipc	s2,0x228
    80001038:	8e490913          	addi	s2,s2,-1820 # 80228918 <pid_lock>
    8000103c:	854a                	mv	a0,s2
    8000103e:	00005097          	auipc	ra,0x5
    80001042:	296080e7          	jalr	662(ra) # 800062d4 <acquire>
  pid = nextpid;
    80001046:	00007797          	auipc	a5,0x7
    8000104a:	7fe78793          	addi	a5,a5,2046 # 80008844 <nextpid>
    8000104e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001050:	0014871b          	addiw	a4,s1,1
    80001054:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001056:	854a                	mv	a0,s2
    80001058:	00005097          	auipc	ra,0x5
    8000105c:	330080e7          	jalr	816(ra) # 80006388 <release>
}
    80001060:	8526                	mv	a0,s1
    80001062:	60e2                	ld	ra,24(sp)
    80001064:	6442                	ld	s0,16(sp)
    80001066:	64a2                	ld	s1,8(sp)
    80001068:	6902                	ld	s2,0(sp)
    8000106a:	6105                	addi	sp,sp,32
    8000106c:	8082                	ret

000000008000106e <proc_pagetable>:
{
    8000106e:	1101                	addi	sp,sp,-32
    80001070:	ec06                	sd	ra,24(sp)
    80001072:	e822                	sd	s0,16(sp)
    80001074:	e426                	sd	s1,8(sp)
    80001076:	e04a                	sd	s2,0(sp)
    80001078:	1000                	addi	s0,sp,32
    8000107a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000107c:	fffff097          	auipc	ra,0xfffff
    80001080:	7d2080e7          	jalr	2002(ra) # 8000084e <uvmcreate>
    80001084:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001086:	c121                	beqz	a0,800010c6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001088:	4729                	li	a4,10
    8000108a:	00006697          	auipc	a3,0x6
    8000108e:	f7668693          	addi	a3,a3,-138 # 80007000 <_trampoline>
    80001092:	6605                	lui	a2,0x1
    80001094:	040005b7          	lui	a1,0x4000
    80001098:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000109a:	05b2                	slli	a1,a1,0xc
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	528080e7          	jalr	1320(ra) # 800005c4 <mappages>
    800010a4:	02054863          	bltz	a0,800010d4 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010a8:	4719                	li	a4,6
    800010aa:	05893683          	ld	a3,88(s2)
    800010ae:	6605                	lui	a2,0x1
    800010b0:	020005b7          	lui	a1,0x2000
    800010b4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010b6:	05b6                	slli	a1,a1,0xd
    800010b8:	8526                	mv	a0,s1
    800010ba:	fffff097          	auipc	ra,0xfffff
    800010be:	50a080e7          	jalr	1290(ra) # 800005c4 <mappages>
    800010c2:	02054163          	bltz	a0,800010e4 <proc_pagetable+0x76>
}
    800010c6:	8526                	mv	a0,s1
    800010c8:	60e2                	ld	ra,24(sp)
    800010ca:	6442                	ld	s0,16(sp)
    800010cc:	64a2                	ld	s1,8(sp)
    800010ce:	6902                	ld	s2,0(sp)
    800010d0:	6105                	addi	sp,sp,32
    800010d2:	8082                	ret
    uvmfree(pagetable, 0);
    800010d4:	4581                	li	a1,0
    800010d6:	8526                	mv	a0,s1
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	97c080e7          	jalr	-1668(ra) # 80000a54 <uvmfree>
    return 0;
    800010e0:	4481                	li	s1,0
    800010e2:	b7d5                	j	800010c6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010e4:	4681                	li	a3,0
    800010e6:	4605                	li	a2,1
    800010e8:	040005b7          	lui	a1,0x4000
    800010ec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010ee:	05b2                	slli	a1,a1,0xc
    800010f0:	8526                	mv	a0,s1
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	698080e7          	jalr	1688(ra) # 8000078a <uvmunmap>
    uvmfree(pagetable, 0);
    800010fa:	4581                	li	a1,0
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	956080e7          	jalr	-1706(ra) # 80000a54 <uvmfree>
    return 0;
    80001106:	4481                	li	s1,0
    80001108:	bf7d                	j	800010c6 <proc_pagetable+0x58>

000000008000110a <proc_freepagetable>:
{
    8000110a:	1101                	addi	sp,sp,-32
    8000110c:	ec06                	sd	ra,24(sp)
    8000110e:	e822                	sd	s0,16(sp)
    80001110:	e426                	sd	s1,8(sp)
    80001112:	e04a                	sd	s2,0(sp)
    80001114:	1000                	addi	s0,sp,32
    80001116:	84aa                	mv	s1,a0
    80001118:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000111a:	4681                	li	a3,0
    8000111c:	4605                	li	a2,1
    8000111e:	040005b7          	lui	a1,0x4000
    80001122:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001124:	05b2                	slli	a1,a1,0xc
    80001126:	fffff097          	auipc	ra,0xfffff
    8000112a:	664080e7          	jalr	1636(ra) # 8000078a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000112e:	4681                	li	a3,0
    80001130:	4605                	li	a2,1
    80001132:	020005b7          	lui	a1,0x2000
    80001136:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001138:	05b6                	slli	a1,a1,0xd
    8000113a:	8526                	mv	a0,s1
    8000113c:	fffff097          	auipc	ra,0xfffff
    80001140:	64e080e7          	jalr	1614(ra) # 8000078a <uvmunmap>
  uvmfree(pagetable, sz);
    80001144:	85ca                	mv	a1,s2
    80001146:	8526                	mv	a0,s1
    80001148:	00000097          	auipc	ra,0x0
    8000114c:	90c080e7          	jalr	-1780(ra) # 80000a54 <uvmfree>
}
    80001150:	60e2                	ld	ra,24(sp)
    80001152:	6442                	ld	s0,16(sp)
    80001154:	64a2                	ld	s1,8(sp)
    80001156:	6902                	ld	s2,0(sp)
    80001158:	6105                	addi	sp,sp,32
    8000115a:	8082                	ret

000000008000115c <freeproc>:
{
    8000115c:	1101                	addi	sp,sp,-32
    8000115e:	ec06                	sd	ra,24(sp)
    80001160:	e822                	sd	s0,16(sp)
    80001162:	e426                	sd	s1,8(sp)
    80001164:	1000                	addi	s0,sp,32
    80001166:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001168:	6d28                	ld	a0,88(a0)
    8000116a:	c509                	beqz	a0,80001174 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000116c:	fffff097          	auipc	ra,0xfffff
    80001170:	eb0080e7          	jalr	-336(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001174:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001178:	68a8                	ld	a0,80(s1)
    8000117a:	c511                	beqz	a0,80001186 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000117c:	64ac                	ld	a1,72(s1)
    8000117e:	00000097          	auipc	ra,0x0
    80001182:	f8c080e7          	jalr	-116(ra) # 8000110a <proc_freepagetable>
  p->pagetable = 0;
    80001186:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000118a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000118e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001192:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001196:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000119a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000119e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011a2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011a6:	0004ac23          	sw	zero,24(s1)
}
    800011aa:	60e2                	ld	ra,24(sp)
    800011ac:	6442                	ld	s0,16(sp)
    800011ae:	64a2                	ld	s1,8(sp)
    800011b0:	6105                	addi	sp,sp,32
    800011b2:	8082                	ret

00000000800011b4 <allocproc>:
{
    800011b4:	1101                	addi	sp,sp,-32
    800011b6:	ec06                	sd	ra,24(sp)
    800011b8:	e822                	sd	s0,16(sp)
    800011ba:	e426                	sd	s1,8(sp)
    800011bc:	e04a                	sd	s2,0(sp)
    800011be:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011c0:	00228497          	auipc	s1,0x228
    800011c4:	b8848493          	addi	s1,s1,-1144 # 80228d48 <proc>
    800011c8:	0022d917          	auipc	s2,0x22d
    800011cc:	58090913          	addi	s2,s2,1408 # 8022e748 <tickslock>
    acquire(&p->lock);
    800011d0:	8526                	mv	a0,s1
    800011d2:	00005097          	auipc	ra,0x5
    800011d6:	102080e7          	jalr	258(ra) # 800062d4 <acquire>
    if(p->state == UNUSED) {
    800011da:	4c9c                	lw	a5,24(s1)
    800011dc:	cf81                	beqz	a5,800011f4 <allocproc+0x40>
      release(&p->lock);
    800011de:	8526                	mv	a0,s1
    800011e0:	00005097          	auipc	ra,0x5
    800011e4:	1a8080e7          	jalr	424(ra) # 80006388 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e8:	16848493          	addi	s1,s1,360
    800011ec:	ff2492e3          	bne	s1,s2,800011d0 <allocproc+0x1c>
  return 0;
    800011f0:	4481                	li	s1,0
    800011f2:	a889                	j	80001244 <allocproc+0x90>
  p->pid = allocpid();
    800011f4:	00000097          	auipc	ra,0x0
    800011f8:	e34080e7          	jalr	-460(ra) # 80001028 <allocpid>
    800011fc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011fe:	4785                	li	a5,1
    80001200:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	f5c080e7          	jalr	-164(ra) # 8000015e <kalloc>
    8000120a:	892a                	mv	s2,a0
    8000120c:	eca8                	sd	a0,88(s1)
    8000120e:	c131                	beqz	a0,80001252 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001210:	8526                	mv	a0,s1
    80001212:	00000097          	auipc	ra,0x0
    80001216:	e5c080e7          	jalr	-420(ra) # 8000106e <proc_pagetable>
    8000121a:	892a                	mv	s2,a0
    8000121c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000121e:	c531                	beqz	a0,8000126a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001220:	07000613          	li	a2,112
    80001224:	4581                	li	a1,0
    80001226:	06048513          	addi	a0,s1,96
    8000122a:	fffff097          	auipc	ra,0xfffff
    8000122e:	fce080e7          	jalr	-50(ra) # 800001f8 <memset>
  p->context.ra = (uint64)forkret;
    80001232:	00000797          	auipc	a5,0x0
    80001236:	db078793          	addi	a5,a5,-592 # 80000fe2 <forkret>
    8000123a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000123c:	60bc                	ld	a5,64(s1)
    8000123e:	6705                	lui	a4,0x1
    80001240:	97ba                	add	a5,a5,a4
    80001242:	f4bc                	sd	a5,104(s1)
}
    80001244:	8526                	mv	a0,s1
    80001246:	60e2                	ld	ra,24(sp)
    80001248:	6442                	ld	s0,16(sp)
    8000124a:	64a2                	ld	s1,8(sp)
    8000124c:	6902                	ld	s2,0(sp)
    8000124e:	6105                	addi	sp,sp,32
    80001250:	8082                	ret
    freeproc(p);
    80001252:	8526                	mv	a0,s1
    80001254:	00000097          	auipc	ra,0x0
    80001258:	f08080e7          	jalr	-248(ra) # 8000115c <freeproc>
    release(&p->lock);
    8000125c:	8526                	mv	a0,s1
    8000125e:	00005097          	auipc	ra,0x5
    80001262:	12a080e7          	jalr	298(ra) # 80006388 <release>
    return 0;
    80001266:	84ca                	mv	s1,s2
    80001268:	bff1                	j	80001244 <allocproc+0x90>
    freeproc(p);
    8000126a:	8526                	mv	a0,s1
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	ef0080e7          	jalr	-272(ra) # 8000115c <freeproc>
    release(&p->lock);
    80001274:	8526                	mv	a0,s1
    80001276:	00005097          	auipc	ra,0x5
    8000127a:	112080e7          	jalr	274(ra) # 80006388 <release>
    return 0;
    8000127e:	84ca                	mv	s1,s2
    80001280:	b7d1                	j	80001244 <allocproc+0x90>

0000000080001282 <userinit>:
{
    80001282:	1101                	addi	sp,sp,-32
    80001284:	ec06                	sd	ra,24(sp)
    80001286:	e822                	sd	s0,16(sp)
    80001288:	e426                	sd	s1,8(sp)
    8000128a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000128c:	00000097          	auipc	ra,0x0
    80001290:	f28080e7          	jalr	-216(ra) # 800011b4 <allocproc>
    80001294:	84aa                	mv	s1,a0
  initproc = p;
    80001296:	00007797          	auipc	a5,0x7
    8000129a:	62a7b523          	sd	a0,1578(a5) # 800088c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000129e:	03400613          	li	a2,52
    800012a2:	00007597          	auipc	a1,0x7
    800012a6:	5ae58593          	addi	a1,a1,1454 # 80008850 <initcode>
    800012aa:	6928                	ld	a0,80(a0)
    800012ac:	fffff097          	auipc	ra,0xfffff
    800012b0:	5d0080e7          	jalr	1488(ra) # 8000087c <uvmfirst>
  p->sz = PGSIZE;
    800012b4:	6785                	lui	a5,0x1
    800012b6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012b8:	6cb8                	ld	a4,88(s1)
    800012ba:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012be:	6cb8                	ld	a4,88(s1)
    800012c0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012c2:	4641                	li	a2,16
    800012c4:	00007597          	auipc	a1,0x7
    800012c8:	ebc58593          	addi	a1,a1,-324 # 80008180 <etext+0x180>
    800012cc:	15848513          	addi	a0,s1,344
    800012d0:	fffff097          	auipc	ra,0xfffff
    800012d4:	072080e7          	jalr	114(ra) # 80000342 <safestrcpy>
  p->cwd = namei("/");
    800012d8:	00007517          	auipc	a0,0x7
    800012dc:	eb850513          	addi	a0,a0,-328 # 80008190 <etext+0x190>
    800012e0:	00002097          	auipc	ra,0x2
    800012e4:	1b4080e7          	jalr	436(ra) # 80003494 <namei>
    800012e8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800012ec:	478d                	li	a5,3
    800012ee:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012f0:	8526                	mv	a0,s1
    800012f2:	00005097          	auipc	ra,0x5
    800012f6:	096080e7          	jalr	150(ra) # 80006388 <release>
}
    800012fa:	60e2                	ld	ra,24(sp)
    800012fc:	6442                	ld	s0,16(sp)
    800012fe:	64a2                	ld	s1,8(sp)
    80001300:	6105                	addi	sp,sp,32
    80001302:	8082                	ret

0000000080001304 <growproc>:
{
    80001304:	1101                	addi	sp,sp,-32
    80001306:	ec06                	sd	ra,24(sp)
    80001308:	e822                	sd	s0,16(sp)
    8000130a:	e426                	sd	s1,8(sp)
    8000130c:	e04a                	sd	s2,0(sp)
    8000130e:	1000                	addi	s0,sp,32
    80001310:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001312:	00000097          	auipc	ra,0x0
    80001316:	c98080e7          	jalr	-872(ra) # 80000faa <myproc>
    8000131a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000131c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000131e:	01204c63          	bgtz	s2,80001336 <growproc+0x32>
  } else if(n < 0){
    80001322:	02094663          	bltz	s2,8000134e <growproc+0x4a>
  p->sz = sz;
    80001326:	e4ac                	sd	a1,72(s1)
  return 0;
    80001328:	4501                	li	a0,0
}
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6902                	ld	s2,0(sp)
    80001332:	6105                	addi	sp,sp,32
    80001334:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001336:	4691                	li	a3,4
    80001338:	00b90633          	add	a2,s2,a1
    8000133c:	6928                	ld	a0,80(a0)
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	5f8080e7          	jalr	1528(ra) # 80000936 <uvmalloc>
    80001346:	85aa                	mv	a1,a0
    80001348:	fd79                	bnez	a0,80001326 <growproc+0x22>
      return -1;
    8000134a:	557d                	li	a0,-1
    8000134c:	bff9                	j	8000132a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000134e:	00b90633          	add	a2,s2,a1
    80001352:	6928                	ld	a0,80(a0)
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	59a080e7          	jalr	1434(ra) # 800008ee <uvmdealloc>
    8000135c:	85aa                	mv	a1,a0
    8000135e:	b7e1                	j	80001326 <growproc+0x22>

0000000080001360 <fork>:
{
    80001360:	7139                	addi	sp,sp,-64
    80001362:	fc06                	sd	ra,56(sp)
    80001364:	f822                	sd	s0,48(sp)
    80001366:	f426                	sd	s1,40(sp)
    80001368:	f04a                	sd	s2,32(sp)
    8000136a:	ec4e                	sd	s3,24(sp)
    8000136c:	e852                	sd	s4,16(sp)
    8000136e:	e456                	sd	s5,8(sp)
    80001370:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001372:	00000097          	auipc	ra,0x0
    80001376:	c38080e7          	jalr	-968(ra) # 80000faa <myproc>
    8000137a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000137c:	00000097          	auipc	ra,0x0
    80001380:	e38080e7          	jalr	-456(ra) # 800011b4 <allocproc>
    80001384:	10050c63          	beqz	a0,8000149c <fork+0x13c>
    80001388:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000138a:	048ab603          	ld	a2,72(s5)
    8000138e:	692c                	ld	a1,80(a0)
    80001390:	050ab503          	ld	a0,80(s5)
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	6fa080e7          	jalr	1786(ra) # 80000a8e <uvmcopy>
    8000139c:	04054863          	bltz	a0,800013ec <fork+0x8c>
  np->sz = p->sz;
    800013a0:	048ab783          	ld	a5,72(s5)
    800013a4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013a8:	058ab683          	ld	a3,88(s5)
    800013ac:	87b6                	mv	a5,a3
    800013ae:	058a3703          	ld	a4,88(s4)
    800013b2:	12068693          	addi	a3,a3,288
    800013b6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013ba:	6788                	ld	a0,8(a5)
    800013bc:	6b8c                	ld	a1,16(a5)
    800013be:	6f90                	ld	a2,24(a5)
    800013c0:	01073023          	sd	a6,0(a4)
    800013c4:	e708                	sd	a0,8(a4)
    800013c6:	eb0c                	sd	a1,16(a4)
    800013c8:	ef10                	sd	a2,24(a4)
    800013ca:	02078793          	addi	a5,a5,32
    800013ce:	02070713          	addi	a4,a4,32
    800013d2:	fed792e3          	bne	a5,a3,800013b6 <fork+0x56>
  np->trapframe->a0 = 0;
    800013d6:	058a3783          	ld	a5,88(s4)
    800013da:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013de:	0d0a8493          	addi	s1,s5,208
    800013e2:	0d0a0913          	addi	s2,s4,208
    800013e6:	150a8993          	addi	s3,s5,336
    800013ea:	a00d                	j	8000140c <fork+0xac>
    freeproc(np);
    800013ec:	8552                	mv	a0,s4
    800013ee:	00000097          	auipc	ra,0x0
    800013f2:	d6e080e7          	jalr	-658(ra) # 8000115c <freeproc>
    release(&np->lock);
    800013f6:	8552                	mv	a0,s4
    800013f8:	00005097          	auipc	ra,0x5
    800013fc:	f90080e7          	jalr	-112(ra) # 80006388 <release>
    return -1;
    80001400:	597d                	li	s2,-1
    80001402:	a059                	j	80001488 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001404:	04a1                	addi	s1,s1,8
    80001406:	0921                	addi	s2,s2,8
    80001408:	01348b63          	beq	s1,s3,8000141e <fork+0xbe>
    if(p->ofile[i])
    8000140c:	6088                	ld	a0,0(s1)
    8000140e:	d97d                	beqz	a0,80001404 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001410:	00002097          	auipc	ra,0x2
    80001414:	71a080e7          	jalr	1818(ra) # 80003b2a <filedup>
    80001418:	00a93023          	sd	a0,0(s2)
    8000141c:	b7e5                	j	80001404 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000141e:	150ab503          	ld	a0,336(s5)
    80001422:	00002097          	auipc	ra,0x2
    80001426:	888080e7          	jalr	-1912(ra) # 80002caa <idup>
    8000142a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000142e:	4641                	li	a2,16
    80001430:	158a8593          	addi	a1,s5,344
    80001434:	158a0513          	addi	a0,s4,344
    80001438:	fffff097          	auipc	ra,0xfffff
    8000143c:	f0a080e7          	jalr	-246(ra) # 80000342 <safestrcpy>
  pid = np->pid;
    80001440:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001444:	8552                	mv	a0,s4
    80001446:	00005097          	auipc	ra,0x5
    8000144a:	f42080e7          	jalr	-190(ra) # 80006388 <release>
  acquire(&wait_lock);
    8000144e:	00227497          	auipc	s1,0x227
    80001452:	4e248493          	addi	s1,s1,1250 # 80228930 <wait_lock>
    80001456:	8526                	mv	a0,s1
    80001458:	00005097          	auipc	ra,0x5
    8000145c:	e7c080e7          	jalr	-388(ra) # 800062d4 <acquire>
  np->parent = p;
    80001460:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001464:	8526                	mv	a0,s1
    80001466:	00005097          	auipc	ra,0x5
    8000146a:	f22080e7          	jalr	-222(ra) # 80006388 <release>
  acquire(&np->lock);
    8000146e:	8552                	mv	a0,s4
    80001470:	00005097          	auipc	ra,0x5
    80001474:	e64080e7          	jalr	-412(ra) # 800062d4 <acquire>
  np->state = RUNNABLE;
    80001478:	478d                	li	a5,3
    8000147a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000147e:	8552                	mv	a0,s4
    80001480:	00005097          	auipc	ra,0x5
    80001484:	f08080e7          	jalr	-248(ra) # 80006388 <release>
}
    80001488:	854a                	mv	a0,s2
    8000148a:	70e2                	ld	ra,56(sp)
    8000148c:	7442                	ld	s0,48(sp)
    8000148e:	74a2                	ld	s1,40(sp)
    80001490:	7902                	ld	s2,32(sp)
    80001492:	69e2                	ld	s3,24(sp)
    80001494:	6a42                	ld	s4,16(sp)
    80001496:	6aa2                	ld	s5,8(sp)
    80001498:	6121                	addi	sp,sp,64
    8000149a:	8082                	ret
    return -1;
    8000149c:	597d                	li	s2,-1
    8000149e:	b7ed                	j	80001488 <fork+0x128>

00000000800014a0 <scheduler>:
{
    800014a0:	7139                	addi	sp,sp,-64
    800014a2:	fc06                	sd	ra,56(sp)
    800014a4:	f822                	sd	s0,48(sp)
    800014a6:	f426                	sd	s1,40(sp)
    800014a8:	f04a                	sd	s2,32(sp)
    800014aa:	ec4e                	sd	s3,24(sp)
    800014ac:	e852                	sd	s4,16(sp)
    800014ae:	e456                	sd	s5,8(sp)
    800014b0:	e05a                	sd	s6,0(sp)
    800014b2:	0080                	addi	s0,sp,64
    800014b4:	8792                	mv	a5,tp
  int id = r_tp();
    800014b6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014b8:	00779a93          	slli	s5,a5,0x7
    800014bc:	00227717          	auipc	a4,0x227
    800014c0:	45c70713          	addi	a4,a4,1116 # 80228918 <pid_lock>
    800014c4:	9756                	add	a4,a4,s5
    800014c6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014ca:	00227717          	auipc	a4,0x227
    800014ce:	48670713          	addi	a4,a4,1158 # 80228950 <cpus+0x8>
    800014d2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014d4:	498d                	li	s3,3
        p->state = RUNNING;
    800014d6:	4b11                	li	s6,4
        c->proc = p;
    800014d8:	079e                	slli	a5,a5,0x7
    800014da:	00227a17          	auipc	s4,0x227
    800014de:	43ea0a13          	addi	s4,s4,1086 # 80228918 <pid_lock>
    800014e2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014e4:	0022d917          	auipc	s2,0x22d
    800014e8:	26490913          	addi	s2,s2,612 # 8022e748 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014f4:	10079073          	csrw	sstatus,a5
    800014f8:	00228497          	auipc	s1,0x228
    800014fc:	85048493          	addi	s1,s1,-1968 # 80228d48 <proc>
    80001500:	a811                	j	80001514 <scheduler+0x74>
      release(&p->lock);
    80001502:	8526                	mv	a0,s1
    80001504:	00005097          	auipc	ra,0x5
    80001508:	e84080e7          	jalr	-380(ra) # 80006388 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000150c:	16848493          	addi	s1,s1,360
    80001510:	fd248ee3          	beq	s1,s2,800014ec <scheduler+0x4c>
      acquire(&p->lock);
    80001514:	8526                	mv	a0,s1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	dbe080e7          	jalr	-578(ra) # 800062d4 <acquire>
      if(p->state == RUNNABLE) {
    8000151e:	4c9c                	lw	a5,24(s1)
    80001520:	ff3791e3          	bne	a5,s3,80001502 <scheduler+0x62>
        p->state = RUNNING;
    80001524:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001528:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000152c:	06048593          	addi	a1,s1,96
    80001530:	8556                	mv	a0,s5
    80001532:	00000097          	auipc	ra,0x0
    80001536:	684080e7          	jalr	1668(ra) # 80001bb6 <swtch>
        c->proc = 0;
    8000153a:	020a3823          	sd	zero,48(s4)
    8000153e:	b7d1                	j	80001502 <scheduler+0x62>

0000000080001540 <sched>:
{
    80001540:	7179                	addi	sp,sp,-48
    80001542:	f406                	sd	ra,40(sp)
    80001544:	f022                	sd	s0,32(sp)
    80001546:	ec26                	sd	s1,24(sp)
    80001548:	e84a                	sd	s2,16(sp)
    8000154a:	e44e                	sd	s3,8(sp)
    8000154c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	a5c080e7          	jalr	-1444(ra) # 80000faa <myproc>
    80001556:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	d02080e7          	jalr	-766(ra) # 8000625a <holding>
    80001560:	c93d                	beqz	a0,800015d6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001562:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001564:	2781                	sext.w	a5,a5
    80001566:	079e                	slli	a5,a5,0x7
    80001568:	00227717          	auipc	a4,0x227
    8000156c:	3b070713          	addi	a4,a4,944 # 80228918 <pid_lock>
    80001570:	97ba                	add	a5,a5,a4
    80001572:	0a87a703          	lw	a4,168(a5)
    80001576:	4785                	li	a5,1
    80001578:	06f71763          	bne	a4,a5,800015e6 <sched+0xa6>
  if(p->state == RUNNING)
    8000157c:	4c98                	lw	a4,24(s1)
    8000157e:	4791                	li	a5,4
    80001580:	06f70b63          	beq	a4,a5,800015f6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001584:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001588:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000158a:	efb5                	bnez	a5,80001606 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000158c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000158e:	00227917          	auipc	s2,0x227
    80001592:	38a90913          	addi	s2,s2,906 # 80228918 <pid_lock>
    80001596:	2781                	sext.w	a5,a5
    80001598:	079e                	slli	a5,a5,0x7
    8000159a:	97ca                	add	a5,a5,s2
    8000159c:	0ac7a983          	lw	s3,172(a5)
    800015a0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015a2:	2781                	sext.w	a5,a5
    800015a4:	079e                	slli	a5,a5,0x7
    800015a6:	00227597          	auipc	a1,0x227
    800015aa:	3aa58593          	addi	a1,a1,938 # 80228950 <cpus+0x8>
    800015ae:	95be                	add	a1,a1,a5
    800015b0:	06048513          	addi	a0,s1,96
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	602080e7          	jalr	1538(ra) # 80001bb6 <swtch>
    800015bc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015be:	2781                	sext.w	a5,a5
    800015c0:	079e                	slli	a5,a5,0x7
    800015c2:	993e                	add	s2,s2,a5
    800015c4:	0b392623          	sw	s3,172(s2)
}
    800015c8:	70a2                	ld	ra,40(sp)
    800015ca:	7402                	ld	s0,32(sp)
    800015cc:	64e2                	ld	s1,24(sp)
    800015ce:	6942                	ld	s2,16(sp)
    800015d0:	69a2                	ld	s3,8(sp)
    800015d2:	6145                	addi	sp,sp,48
    800015d4:	8082                	ret
    panic("sched p->lock");
    800015d6:	00007517          	auipc	a0,0x7
    800015da:	bc250513          	addi	a0,a0,-1086 # 80008198 <etext+0x198>
    800015de:	00004097          	auipc	ra,0x4
    800015e2:	7be080e7          	jalr	1982(ra) # 80005d9c <panic>
    panic("sched locks");
    800015e6:	00007517          	auipc	a0,0x7
    800015ea:	bc250513          	addi	a0,a0,-1086 # 800081a8 <etext+0x1a8>
    800015ee:	00004097          	auipc	ra,0x4
    800015f2:	7ae080e7          	jalr	1966(ra) # 80005d9c <panic>
    panic("sched running");
    800015f6:	00007517          	auipc	a0,0x7
    800015fa:	bc250513          	addi	a0,a0,-1086 # 800081b8 <etext+0x1b8>
    800015fe:	00004097          	auipc	ra,0x4
    80001602:	79e080e7          	jalr	1950(ra) # 80005d9c <panic>
    panic("sched interruptible");
    80001606:	00007517          	auipc	a0,0x7
    8000160a:	bc250513          	addi	a0,a0,-1086 # 800081c8 <etext+0x1c8>
    8000160e:	00004097          	auipc	ra,0x4
    80001612:	78e080e7          	jalr	1934(ra) # 80005d9c <panic>

0000000080001616 <yield>:
{
    80001616:	1101                	addi	sp,sp,-32
    80001618:	ec06                	sd	ra,24(sp)
    8000161a:	e822                	sd	s0,16(sp)
    8000161c:	e426                	sd	s1,8(sp)
    8000161e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001620:	00000097          	auipc	ra,0x0
    80001624:	98a080e7          	jalr	-1654(ra) # 80000faa <myproc>
    80001628:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	caa080e7          	jalr	-854(ra) # 800062d4 <acquire>
  p->state = RUNNABLE;
    80001632:	478d                	li	a5,3
    80001634:	cc9c                	sw	a5,24(s1)
  sched();
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	f0a080e7          	jalr	-246(ra) # 80001540 <sched>
  release(&p->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	d48080e7          	jalr	-696(ra) # 80006388 <release>
}
    80001648:	60e2                	ld	ra,24(sp)
    8000164a:	6442                	ld	s0,16(sp)
    8000164c:	64a2                	ld	s1,8(sp)
    8000164e:	6105                	addi	sp,sp,32
    80001650:	8082                	ret

0000000080001652 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001652:	7179                	addi	sp,sp,-48
    80001654:	f406                	sd	ra,40(sp)
    80001656:	f022                	sd	s0,32(sp)
    80001658:	ec26                	sd	s1,24(sp)
    8000165a:	e84a                	sd	s2,16(sp)
    8000165c:	e44e                	sd	s3,8(sp)
    8000165e:	1800                	addi	s0,sp,48
    80001660:	89aa                	mv	s3,a0
    80001662:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001664:	00000097          	auipc	ra,0x0
    80001668:	946080e7          	jalr	-1722(ra) # 80000faa <myproc>
    8000166c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	c66080e7          	jalr	-922(ra) # 800062d4 <acquire>
  release(lk);
    80001676:	854a                	mv	a0,s2
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	d10080e7          	jalr	-752(ra) # 80006388 <release>

  // Go to sleep.
  p->chan = chan;
    80001680:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001684:	4789                	li	a5,2
    80001686:	cc9c                	sw	a5,24(s1)

  sched();
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	eb8080e7          	jalr	-328(ra) # 80001540 <sched>

  // Tidy up.
  p->chan = 0;
    80001690:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	cf2080e7          	jalr	-782(ra) # 80006388 <release>
  acquire(lk);
    8000169e:	854a                	mv	a0,s2
    800016a0:	00005097          	auipc	ra,0x5
    800016a4:	c34080e7          	jalr	-972(ra) # 800062d4 <acquire>
}
    800016a8:	70a2                	ld	ra,40(sp)
    800016aa:	7402                	ld	s0,32(sp)
    800016ac:	64e2                	ld	s1,24(sp)
    800016ae:	6942                	ld	s2,16(sp)
    800016b0:	69a2                	ld	s3,8(sp)
    800016b2:	6145                	addi	sp,sp,48
    800016b4:	8082                	ret

00000000800016b6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016b6:	7139                	addi	sp,sp,-64
    800016b8:	fc06                	sd	ra,56(sp)
    800016ba:	f822                	sd	s0,48(sp)
    800016bc:	f426                	sd	s1,40(sp)
    800016be:	f04a                	sd	s2,32(sp)
    800016c0:	ec4e                	sd	s3,24(sp)
    800016c2:	e852                	sd	s4,16(sp)
    800016c4:	e456                	sd	s5,8(sp)
    800016c6:	0080                	addi	s0,sp,64
    800016c8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016ca:	00227497          	auipc	s1,0x227
    800016ce:	67e48493          	addi	s1,s1,1662 # 80228d48 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016d2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016d4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d6:	0022d917          	auipc	s2,0x22d
    800016da:	07290913          	addi	s2,s2,114 # 8022e748 <tickslock>
    800016de:	a811                	j	800016f2 <wakeup+0x3c>
      }
      release(&p->lock);
    800016e0:	8526                	mv	a0,s1
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	ca6080e7          	jalr	-858(ra) # 80006388 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ea:	16848493          	addi	s1,s1,360
    800016ee:	03248663          	beq	s1,s2,8000171a <wakeup+0x64>
    if(p != myproc()){
    800016f2:	00000097          	auipc	ra,0x0
    800016f6:	8b8080e7          	jalr	-1864(ra) # 80000faa <myproc>
    800016fa:	fea488e3          	beq	s1,a0,800016ea <wakeup+0x34>
      acquire(&p->lock);
    800016fe:	8526                	mv	a0,s1
    80001700:	00005097          	auipc	ra,0x5
    80001704:	bd4080e7          	jalr	-1068(ra) # 800062d4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001708:	4c9c                	lw	a5,24(s1)
    8000170a:	fd379be3          	bne	a5,s3,800016e0 <wakeup+0x2a>
    8000170e:	709c                	ld	a5,32(s1)
    80001710:	fd4798e3          	bne	a5,s4,800016e0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001714:	0154ac23          	sw	s5,24(s1)
    80001718:	b7e1                	j	800016e0 <wakeup+0x2a>
    }
  }
}
    8000171a:	70e2                	ld	ra,56(sp)
    8000171c:	7442                	ld	s0,48(sp)
    8000171e:	74a2                	ld	s1,40(sp)
    80001720:	7902                	ld	s2,32(sp)
    80001722:	69e2                	ld	s3,24(sp)
    80001724:	6a42                	ld	s4,16(sp)
    80001726:	6aa2                	ld	s5,8(sp)
    80001728:	6121                	addi	sp,sp,64
    8000172a:	8082                	ret

000000008000172c <reparent>:
{
    8000172c:	7179                	addi	sp,sp,-48
    8000172e:	f406                	sd	ra,40(sp)
    80001730:	f022                	sd	s0,32(sp)
    80001732:	ec26                	sd	s1,24(sp)
    80001734:	e84a                	sd	s2,16(sp)
    80001736:	e44e                	sd	s3,8(sp)
    80001738:	e052                	sd	s4,0(sp)
    8000173a:	1800                	addi	s0,sp,48
    8000173c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000173e:	00227497          	auipc	s1,0x227
    80001742:	60a48493          	addi	s1,s1,1546 # 80228d48 <proc>
      pp->parent = initproc;
    80001746:	00007a17          	auipc	s4,0x7
    8000174a:	17aa0a13          	addi	s4,s4,378 # 800088c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000174e:	0022d997          	auipc	s3,0x22d
    80001752:	ffa98993          	addi	s3,s3,-6 # 8022e748 <tickslock>
    80001756:	a029                	j	80001760 <reparent+0x34>
    80001758:	16848493          	addi	s1,s1,360
    8000175c:	01348d63          	beq	s1,s3,80001776 <reparent+0x4a>
    if(pp->parent == p){
    80001760:	7c9c                	ld	a5,56(s1)
    80001762:	ff279be3          	bne	a5,s2,80001758 <reparent+0x2c>
      pp->parent = initproc;
    80001766:	000a3503          	ld	a0,0(s4)
    8000176a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000176c:	00000097          	auipc	ra,0x0
    80001770:	f4a080e7          	jalr	-182(ra) # 800016b6 <wakeup>
    80001774:	b7d5                	j	80001758 <reparent+0x2c>
}
    80001776:	70a2                	ld	ra,40(sp)
    80001778:	7402                	ld	s0,32(sp)
    8000177a:	64e2                	ld	s1,24(sp)
    8000177c:	6942                	ld	s2,16(sp)
    8000177e:	69a2                	ld	s3,8(sp)
    80001780:	6a02                	ld	s4,0(sp)
    80001782:	6145                	addi	sp,sp,48
    80001784:	8082                	ret

0000000080001786 <exit>:
{
    80001786:	7179                	addi	sp,sp,-48
    80001788:	f406                	sd	ra,40(sp)
    8000178a:	f022                	sd	s0,32(sp)
    8000178c:	ec26                	sd	s1,24(sp)
    8000178e:	e84a                	sd	s2,16(sp)
    80001790:	e44e                	sd	s3,8(sp)
    80001792:	e052                	sd	s4,0(sp)
    80001794:	1800                	addi	s0,sp,48
    80001796:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	812080e7          	jalr	-2030(ra) # 80000faa <myproc>
    800017a0:	89aa                	mv	s3,a0
  if(p == initproc)
    800017a2:	00007797          	auipc	a5,0x7
    800017a6:	11e7b783          	ld	a5,286(a5) # 800088c0 <initproc>
    800017aa:	0d050493          	addi	s1,a0,208
    800017ae:	15050913          	addi	s2,a0,336
    800017b2:	02a79363          	bne	a5,a0,800017d8 <exit+0x52>
    panic("init exiting");
    800017b6:	00007517          	auipc	a0,0x7
    800017ba:	a2a50513          	addi	a0,a0,-1494 # 800081e0 <etext+0x1e0>
    800017be:	00004097          	auipc	ra,0x4
    800017c2:	5de080e7          	jalr	1502(ra) # 80005d9c <panic>
      fileclose(f);
    800017c6:	00002097          	auipc	ra,0x2
    800017ca:	3b6080e7          	jalr	950(ra) # 80003b7c <fileclose>
      p->ofile[fd] = 0;
    800017ce:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017d2:	04a1                	addi	s1,s1,8
    800017d4:	01248563          	beq	s1,s2,800017de <exit+0x58>
    if(p->ofile[fd]){
    800017d8:	6088                	ld	a0,0(s1)
    800017da:	f575                	bnez	a0,800017c6 <exit+0x40>
    800017dc:	bfdd                	j	800017d2 <exit+0x4c>
  begin_op();
    800017de:	00002097          	auipc	ra,0x2
    800017e2:	ed6080e7          	jalr	-298(ra) # 800036b4 <begin_op>
  iput(p->cwd);
    800017e6:	1509b503          	ld	a0,336(s3)
    800017ea:	00001097          	auipc	ra,0x1
    800017ee:	6b8080e7          	jalr	1720(ra) # 80002ea2 <iput>
  end_op();
    800017f2:	00002097          	auipc	ra,0x2
    800017f6:	f40080e7          	jalr	-192(ra) # 80003732 <end_op>
  p->cwd = 0;
    800017fa:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017fe:	00227497          	auipc	s1,0x227
    80001802:	13248493          	addi	s1,s1,306 # 80228930 <wait_lock>
    80001806:	8526                	mv	a0,s1
    80001808:	00005097          	auipc	ra,0x5
    8000180c:	acc080e7          	jalr	-1332(ra) # 800062d4 <acquire>
  reparent(p);
    80001810:	854e                	mv	a0,s3
    80001812:	00000097          	auipc	ra,0x0
    80001816:	f1a080e7          	jalr	-230(ra) # 8000172c <reparent>
  wakeup(p->parent);
    8000181a:	0389b503          	ld	a0,56(s3)
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	e98080e7          	jalr	-360(ra) # 800016b6 <wakeup>
  acquire(&p->lock);
    80001826:	854e                	mv	a0,s3
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	aac080e7          	jalr	-1364(ra) # 800062d4 <acquire>
  p->xstate = status;
    80001830:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001834:	4795                	li	a5,5
    80001836:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000183a:	8526                	mv	a0,s1
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	b4c080e7          	jalr	-1204(ra) # 80006388 <release>
  sched();
    80001844:	00000097          	auipc	ra,0x0
    80001848:	cfc080e7          	jalr	-772(ra) # 80001540 <sched>
  panic("zombie exit");
    8000184c:	00007517          	auipc	a0,0x7
    80001850:	9a450513          	addi	a0,a0,-1628 # 800081f0 <etext+0x1f0>
    80001854:	00004097          	auipc	ra,0x4
    80001858:	548080e7          	jalr	1352(ra) # 80005d9c <panic>

000000008000185c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000185c:	7179                	addi	sp,sp,-48
    8000185e:	f406                	sd	ra,40(sp)
    80001860:	f022                	sd	s0,32(sp)
    80001862:	ec26                	sd	s1,24(sp)
    80001864:	e84a                	sd	s2,16(sp)
    80001866:	e44e                	sd	s3,8(sp)
    80001868:	1800                	addi	s0,sp,48
    8000186a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000186c:	00227497          	auipc	s1,0x227
    80001870:	4dc48493          	addi	s1,s1,1244 # 80228d48 <proc>
    80001874:	0022d997          	auipc	s3,0x22d
    80001878:	ed498993          	addi	s3,s3,-300 # 8022e748 <tickslock>
    acquire(&p->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	a56080e7          	jalr	-1450(ra) # 800062d4 <acquire>
    if(p->pid == pid){
    80001886:	589c                	lw	a5,48(s1)
    80001888:	01278d63          	beq	a5,s2,800018a2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000188c:	8526                	mv	a0,s1
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	afa080e7          	jalr	-1286(ra) # 80006388 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001896:	16848493          	addi	s1,s1,360
    8000189a:	ff3491e3          	bne	s1,s3,8000187c <kill+0x20>
  }
  return -1;
    8000189e:	557d                	li	a0,-1
    800018a0:	a829                	j	800018ba <kill+0x5e>
      p->killed = 1;
    800018a2:	4785                	li	a5,1
    800018a4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018a6:	4c98                	lw	a4,24(s1)
    800018a8:	4789                	li	a5,2
    800018aa:	00f70f63          	beq	a4,a5,800018c8 <kill+0x6c>
      release(&p->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	ad8080e7          	jalr	-1320(ra) # 80006388 <release>
      return 0;
    800018b8:	4501                	li	a0,0
}
    800018ba:	70a2                	ld	ra,40(sp)
    800018bc:	7402                	ld	s0,32(sp)
    800018be:	64e2                	ld	s1,24(sp)
    800018c0:	6942                	ld	s2,16(sp)
    800018c2:	69a2                	ld	s3,8(sp)
    800018c4:	6145                	addi	sp,sp,48
    800018c6:	8082                	ret
        p->state = RUNNABLE;
    800018c8:	478d                	li	a5,3
    800018ca:	cc9c                	sw	a5,24(s1)
    800018cc:	b7cd                	j	800018ae <kill+0x52>

00000000800018ce <setkilled>:

void
setkilled(struct proc *p)
{
    800018ce:	1101                	addi	sp,sp,-32
    800018d0:	ec06                	sd	ra,24(sp)
    800018d2:	e822                	sd	s0,16(sp)
    800018d4:	e426                	sd	s1,8(sp)
    800018d6:	1000                	addi	s0,sp,32
    800018d8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800018da:	00005097          	auipc	ra,0x5
    800018de:	9fa080e7          	jalr	-1542(ra) # 800062d4 <acquire>
  p->killed = 1;
    800018e2:	4785                	li	a5,1
    800018e4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800018e6:	8526                	mv	a0,s1
    800018e8:	00005097          	auipc	ra,0x5
    800018ec:	aa0080e7          	jalr	-1376(ra) # 80006388 <release>
}
    800018f0:	60e2                	ld	ra,24(sp)
    800018f2:	6442                	ld	s0,16(sp)
    800018f4:	64a2                	ld	s1,8(sp)
    800018f6:	6105                	addi	sp,sp,32
    800018f8:	8082                	ret

00000000800018fa <killed>:

int
killed(struct proc *p)
{
    800018fa:	1101                	addi	sp,sp,-32
    800018fc:	ec06                	sd	ra,24(sp)
    800018fe:	e822                	sd	s0,16(sp)
    80001900:	e426                	sd	s1,8(sp)
    80001902:	e04a                	sd	s2,0(sp)
    80001904:	1000                	addi	s0,sp,32
    80001906:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001908:	00005097          	auipc	ra,0x5
    8000190c:	9cc080e7          	jalr	-1588(ra) # 800062d4 <acquire>
  k = p->killed;
    80001910:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001914:	8526                	mv	a0,s1
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	a72080e7          	jalr	-1422(ra) # 80006388 <release>
  return k;
}
    8000191e:	854a                	mv	a0,s2
    80001920:	60e2                	ld	ra,24(sp)
    80001922:	6442                	ld	s0,16(sp)
    80001924:	64a2                	ld	s1,8(sp)
    80001926:	6902                	ld	s2,0(sp)
    80001928:	6105                	addi	sp,sp,32
    8000192a:	8082                	ret

000000008000192c <wait>:
{
    8000192c:	715d                	addi	sp,sp,-80
    8000192e:	e486                	sd	ra,72(sp)
    80001930:	e0a2                	sd	s0,64(sp)
    80001932:	fc26                	sd	s1,56(sp)
    80001934:	f84a                	sd	s2,48(sp)
    80001936:	f44e                	sd	s3,40(sp)
    80001938:	f052                	sd	s4,32(sp)
    8000193a:	ec56                	sd	s5,24(sp)
    8000193c:	e85a                	sd	s6,16(sp)
    8000193e:	e45e                	sd	s7,8(sp)
    80001940:	e062                	sd	s8,0(sp)
    80001942:	0880                	addi	s0,sp,80
    80001944:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	664080e7          	jalr	1636(ra) # 80000faa <myproc>
    8000194e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001950:	00227517          	auipc	a0,0x227
    80001954:	fe050513          	addi	a0,a0,-32 # 80228930 <wait_lock>
    80001958:	00005097          	auipc	ra,0x5
    8000195c:	97c080e7          	jalr	-1668(ra) # 800062d4 <acquire>
    havekids = 0;
    80001960:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001962:	4a15                	li	s4,5
        havekids = 1;
    80001964:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001966:	0022d997          	auipc	s3,0x22d
    8000196a:	de298993          	addi	s3,s3,-542 # 8022e748 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000196e:	00227c17          	auipc	s8,0x227
    80001972:	fc2c0c13          	addi	s8,s8,-62 # 80228930 <wait_lock>
    havekids = 0;
    80001976:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001978:	00227497          	auipc	s1,0x227
    8000197c:	3d048493          	addi	s1,s1,976 # 80228d48 <proc>
    80001980:	a0bd                	j	800019ee <wait+0xc2>
          pid = pp->pid;
    80001982:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001986:	000b0e63          	beqz	s6,800019a2 <wait+0x76>
    8000198a:	4691                	li	a3,4
    8000198c:	02c48613          	addi	a2,s1,44
    80001990:	85da                	mv	a1,s6
    80001992:	05093503          	ld	a0,80(s2)
    80001996:	fffff097          	auipc	ra,0xfffff
    8000199a:	246080e7          	jalr	582(ra) # 80000bdc <copyout>
    8000199e:	02054563          	bltz	a0,800019c8 <wait+0x9c>
          freeproc(pp);
    800019a2:	8526                	mv	a0,s1
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	7b8080e7          	jalr	1976(ra) # 8000115c <freeproc>
          release(&pp->lock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	9da080e7          	jalr	-1574(ra) # 80006388 <release>
          release(&wait_lock);
    800019b6:	00227517          	auipc	a0,0x227
    800019ba:	f7a50513          	addi	a0,a0,-134 # 80228930 <wait_lock>
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	9ca080e7          	jalr	-1590(ra) # 80006388 <release>
          return pid;
    800019c6:	a0b5                	j	80001a32 <wait+0x106>
            release(&pp->lock);
    800019c8:	8526                	mv	a0,s1
    800019ca:	00005097          	auipc	ra,0x5
    800019ce:	9be080e7          	jalr	-1602(ra) # 80006388 <release>
            release(&wait_lock);
    800019d2:	00227517          	auipc	a0,0x227
    800019d6:	f5e50513          	addi	a0,a0,-162 # 80228930 <wait_lock>
    800019da:	00005097          	auipc	ra,0x5
    800019de:	9ae080e7          	jalr	-1618(ra) # 80006388 <release>
            return -1;
    800019e2:	59fd                	li	s3,-1
    800019e4:	a0b9                	j	80001a32 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019e6:	16848493          	addi	s1,s1,360
    800019ea:	03348463          	beq	s1,s3,80001a12 <wait+0xe6>
      if(pp->parent == p){
    800019ee:	7c9c                	ld	a5,56(s1)
    800019f0:	ff279be3          	bne	a5,s2,800019e6 <wait+0xba>
        acquire(&pp->lock);
    800019f4:	8526                	mv	a0,s1
    800019f6:	00005097          	auipc	ra,0x5
    800019fa:	8de080e7          	jalr	-1826(ra) # 800062d4 <acquire>
        if(pp->state == ZOMBIE){
    800019fe:	4c9c                	lw	a5,24(s1)
    80001a00:	f94781e3          	beq	a5,s4,80001982 <wait+0x56>
        release(&pp->lock);
    80001a04:	8526                	mv	a0,s1
    80001a06:	00005097          	auipc	ra,0x5
    80001a0a:	982080e7          	jalr	-1662(ra) # 80006388 <release>
        havekids = 1;
    80001a0e:	8756                	mv	a4,s5
    80001a10:	bfd9                	j	800019e6 <wait+0xba>
    if(!havekids || killed(p)){
    80001a12:	c719                	beqz	a4,80001a20 <wait+0xf4>
    80001a14:	854a                	mv	a0,s2
    80001a16:	00000097          	auipc	ra,0x0
    80001a1a:	ee4080e7          	jalr	-284(ra) # 800018fa <killed>
    80001a1e:	c51d                	beqz	a0,80001a4c <wait+0x120>
      release(&wait_lock);
    80001a20:	00227517          	auipc	a0,0x227
    80001a24:	f1050513          	addi	a0,a0,-240 # 80228930 <wait_lock>
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	960080e7          	jalr	-1696(ra) # 80006388 <release>
      return -1;
    80001a30:	59fd                	li	s3,-1
}
    80001a32:	854e                	mv	a0,s3
    80001a34:	60a6                	ld	ra,72(sp)
    80001a36:	6406                	ld	s0,64(sp)
    80001a38:	74e2                	ld	s1,56(sp)
    80001a3a:	7942                	ld	s2,48(sp)
    80001a3c:	79a2                	ld	s3,40(sp)
    80001a3e:	7a02                	ld	s4,32(sp)
    80001a40:	6ae2                	ld	s5,24(sp)
    80001a42:	6b42                	ld	s6,16(sp)
    80001a44:	6ba2                	ld	s7,8(sp)
    80001a46:	6c02                	ld	s8,0(sp)
    80001a48:	6161                	addi	sp,sp,80
    80001a4a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a4c:	85e2                	mv	a1,s8
    80001a4e:	854a                	mv	a0,s2
    80001a50:	00000097          	auipc	ra,0x0
    80001a54:	c02080e7          	jalr	-1022(ra) # 80001652 <sleep>
    havekids = 0;
    80001a58:	bf39                	j	80001976 <wait+0x4a>

0000000080001a5a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a5a:	7179                	addi	sp,sp,-48
    80001a5c:	f406                	sd	ra,40(sp)
    80001a5e:	f022                	sd	s0,32(sp)
    80001a60:	ec26                	sd	s1,24(sp)
    80001a62:	e84a                	sd	s2,16(sp)
    80001a64:	e44e                	sd	s3,8(sp)
    80001a66:	e052                	sd	s4,0(sp)
    80001a68:	1800                	addi	s0,sp,48
    80001a6a:	84aa                	mv	s1,a0
    80001a6c:	892e                	mv	s2,a1
    80001a6e:	89b2                	mv	s3,a2
    80001a70:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	538080e7          	jalr	1336(ra) # 80000faa <myproc>
  if(user_dst){
    80001a7a:	c08d                	beqz	s1,80001a9c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a7c:	86d2                	mv	a3,s4
    80001a7e:	864e                	mv	a2,s3
    80001a80:	85ca                	mv	a1,s2
    80001a82:	6928                	ld	a0,80(a0)
    80001a84:	fffff097          	auipc	ra,0xfffff
    80001a88:	158080e7          	jalr	344(ra) # 80000bdc <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a8c:	70a2                	ld	ra,40(sp)
    80001a8e:	7402                	ld	s0,32(sp)
    80001a90:	64e2                	ld	s1,24(sp)
    80001a92:	6942                	ld	s2,16(sp)
    80001a94:	69a2                	ld	s3,8(sp)
    80001a96:	6a02                	ld	s4,0(sp)
    80001a98:	6145                	addi	sp,sp,48
    80001a9a:	8082                	ret
    memmove((char *)dst, src, len);
    80001a9c:	000a061b          	sext.w	a2,s4
    80001aa0:	85ce                	mv	a1,s3
    80001aa2:	854a                	mv	a0,s2
    80001aa4:	ffffe097          	auipc	ra,0xffffe
    80001aa8:	7b0080e7          	jalr	1968(ra) # 80000254 <memmove>
    return 0;
    80001aac:	8526                	mv	a0,s1
    80001aae:	bff9                	j	80001a8c <either_copyout+0x32>

0000000080001ab0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ab0:	7179                	addi	sp,sp,-48
    80001ab2:	f406                	sd	ra,40(sp)
    80001ab4:	f022                	sd	s0,32(sp)
    80001ab6:	ec26                	sd	s1,24(sp)
    80001ab8:	e84a                	sd	s2,16(sp)
    80001aba:	e44e                	sd	s3,8(sp)
    80001abc:	e052                	sd	s4,0(sp)
    80001abe:	1800                	addi	s0,sp,48
    80001ac0:	892a                	mv	s2,a0
    80001ac2:	84ae                	mv	s1,a1
    80001ac4:	89b2                	mv	s3,a2
    80001ac6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ac8:	fffff097          	auipc	ra,0xfffff
    80001acc:	4e2080e7          	jalr	1250(ra) # 80000faa <myproc>
  if(user_src){
    80001ad0:	c08d                	beqz	s1,80001af2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ad2:	86d2                	mv	a3,s4
    80001ad4:	864e                	mv	a2,s3
    80001ad6:	85ca                	mv	a1,s2
    80001ad8:	6928                	ld	a0,80(a0)
    80001ada:	fffff097          	auipc	ra,0xfffff
    80001ade:	220080e7          	jalr	544(ra) # 80000cfa <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ae2:	70a2                	ld	ra,40(sp)
    80001ae4:	7402                	ld	s0,32(sp)
    80001ae6:	64e2                	ld	s1,24(sp)
    80001ae8:	6942                	ld	s2,16(sp)
    80001aea:	69a2                	ld	s3,8(sp)
    80001aec:	6a02                	ld	s4,0(sp)
    80001aee:	6145                	addi	sp,sp,48
    80001af0:	8082                	ret
    memmove(dst, (char*)src, len);
    80001af2:	000a061b          	sext.w	a2,s4
    80001af6:	85ce                	mv	a1,s3
    80001af8:	854a                	mv	a0,s2
    80001afa:	ffffe097          	auipc	ra,0xffffe
    80001afe:	75a080e7          	jalr	1882(ra) # 80000254 <memmove>
    return 0;
    80001b02:	8526                	mv	a0,s1
    80001b04:	bff9                	j	80001ae2 <either_copyin+0x32>

0000000080001b06 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b06:	715d                	addi	sp,sp,-80
    80001b08:	e486                	sd	ra,72(sp)
    80001b0a:	e0a2                	sd	s0,64(sp)
    80001b0c:	fc26                	sd	s1,56(sp)
    80001b0e:	f84a                	sd	s2,48(sp)
    80001b10:	f44e                	sd	s3,40(sp)
    80001b12:	f052                	sd	s4,32(sp)
    80001b14:	ec56                	sd	s5,24(sp)
    80001b16:	e85a                	sd	s6,16(sp)
    80001b18:	e45e                	sd	s7,8(sp)
    80001b1a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b1c:	00006517          	auipc	a0,0x6
    80001b20:	52c50513          	addi	a0,a0,1324 # 80008048 <etext+0x48>
    80001b24:	00004097          	auipc	ra,0x4
    80001b28:	2c2080e7          	jalr	706(ra) # 80005de6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b2c:	00227497          	auipc	s1,0x227
    80001b30:	37448493          	addi	s1,s1,884 # 80228ea0 <proc+0x158>
    80001b34:	0022d917          	auipc	s2,0x22d
    80001b38:	d6c90913          	addi	s2,s2,-660 # 8022e8a0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b3c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b3e:	00006997          	auipc	s3,0x6
    80001b42:	6c298993          	addi	s3,s3,1730 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001b46:	00006a97          	auipc	s5,0x6
    80001b4a:	6c2a8a93          	addi	s5,s5,1730 # 80008208 <etext+0x208>
    printf("\n");
    80001b4e:	00006a17          	auipc	s4,0x6
    80001b52:	4faa0a13          	addi	s4,s4,1274 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b56:	00006b97          	auipc	s7,0x6
    80001b5a:	6f2b8b93          	addi	s7,s7,1778 # 80008248 <states.0>
    80001b5e:	a00d                	j	80001b80 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b60:	ed86a583          	lw	a1,-296(a3)
    80001b64:	8556                	mv	a0,s5
    80001b66:	00004097          	auipc	ra,0x4
    80001b6a:	280080e7          	jalr	640(ra) # 80005de6 <printf>
    printf("\n");
    80001b6e:	8552                	mv	a0,s4
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	276080e7          	jalr	630(ra) # 80005de6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b78:	16848493          	addi	s1,s1,360
    80001b7c:	03248263          	beq	s1,s2,80001ba0 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b80:	86a6                	mv	a3,s1
    80001b82:	ec04a783          	lw	a5,-320(s1)
    80001b86:	dbed                	beqz	a5,80001b78 <procdump+0x72>
      state = "???";
    80001b88:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b8a:	fcfb6be3          	bltu	s6,a5,80001b60 <procdump+0x5a>
    80001b8e:	02079713          	slli	a4,a5,0x20
    80001b92:	01d75793          	srli	a5,a4,0x1d
    80001b96:	97de                	add	a5,a5,s7
    80001b98:	6390                	ld	a2,0(a5)
    80001b9a:	f279                	bnez	a2,80001b60 <procdump+0x5a>
      state = "???";
    80001b9c:	864e                	mv	a2,s3
    80001b9e:	b7c9                	j	80001b60 <procdump+0x5a>
  }
}
    80001ba0:	60a6                	ld	ra,72(sp)
    80001ba2:	6406                	ld	s0,64(sp)
    80001ba4:	74e2                	ld	s1,56(sp)
    80001ba6:	7942                	ld	s2,48(sp)
    80001ba8:	79a2                	ld	s3,40(sp)
    80001baa:	7a02                	ld	s4,32(sp)
    80001bac:	6ae2                	ld	s5,24(sp)
    80001bae:	6b42                	ld	s6,16(sp)
    80001bb0:	6ba2                	ld	s7,8(sp)
    80001bb2:	6161                	addi	sp,sp,80
    80001bb4:	8082                	ret

0000000080001bb6 <swtch>:
    80001bb6:	00153023          	sd	ra,0(a0)
    80001bba:	00253423          	sd	sp,8(a0)
    80001bbe:	e900                	sd	s0,16(a0)
    80001bc0:	ed04                	sd	s1,24(a0)
    80001bc2:	03253023          	sd	s2,32(a0)
    80001bc6:	03353423          	sd	s3,40(a0)
    80001bca:	03453823          	sd	s4,48(a0)
    80001bce:	03553c23          	sd	s5,56(a0)
    80001bd2:	05653023          	sd	s6,64(a0)
    80001bd6:	05753423          	sd	s7,72(a0)
    80001bda:	05853823          	sd	s8,80(a0)
    80001bde:	05953c23          	sd	s9,88(a0)
    80001be2:	07a53023          	sd	s10,96(a0)
    80001be6:	07b53423          	sd	s11,104(a0)
    80001bea:	0005b083          	ld	ra,0(a1)
    80001bee:	0085b103          	ld	sp,8(a1)
    80001bf2:	6980                	ld	s0,16(a1)
    80001bf4:	6d84                	ld	s1,24(a1)
    80001bf6:	0205b903          	ld	s2,32(a1)
    80001bfa:	0285b983          	ld	s3,40(a1)
    80001bfe:	0305ba03          	ld	s4,48(a1)
    80001c02:	0385ba83          	ld	s5,56(a1)
    80001c06:	0405bb03          	ld	s6,64(a1)
    80001c0a:	0485bb83          	ld	s7,72(a1)
    80001c0e:	0505bc03          	ld	s8,80(a1)
    80001c12:	0585bc83          	ld	s9,88(a1)
    80001c16:	0605bd03          	ld	s10,96(a1)
    80001c1a:	0685bd83          	ld	s11,104(a1)
    80001c1e:	8082                	ret

0000000080001c20 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c20:	1141                	addi	sp,sp,-16
    80001c22:	e406                	sd	ra,8(sp)
    80001c24:	e022                	sd	s0,0(sp)
    80001c26:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c28:	00006597          	auipc	a1,0x6
    80001c2c:	65058593          	addi	a1,a1,1616 # 80008278 <states.0+0x30>
    80001c30:	0022d517          	auipc	a0,0x22d
    80001c34:	b1850513          	addi	a0,a0,-1256 # 8022e748 <tickslock>
    80001c38:	00004097          	auipc	ra,0x4
    80001c3c:	60c080e7          	jalr	1548(ra) # 80006244 <initlock>
}
    80001c40:	60a2                	ld	ra,8(sp)
    80001c42:	6402                	ld	s0,0(sp)
    80001c44:	0141                	addi	sp,sp,16
    80001c46:	8082                	ret

0000000080001c48 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c48:	1141                	addi	sp,sp,-16
    80001c4a:	e422                	sd	s0,8(sp)
    80001c4c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c4e:	00003797          	auipc	a5,0x3
    80001c52:	58278793          	addi	a5,a5,1410 # 800051d0 <kernelvec>
    80001c56:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c5a:	6422                	ld	s0,8(sp)
    80001c5c:	0141                	addi	sp,sp,16
    80001c5e:	8082                	ret

0000000080001c60 <cowhandler>:

int
cowhandler(pagetable_t pagetable, uint64 va)
{
    char *mem;
    if (va >= MAXVA)
    80001c60:	57fd                	li	a5,-1
    80001c62:	83e9                	srli	a5,a5,0x1a
    80001c64:	08b7e063          	bltu	a5,a1,80001ce4 <cowhandler+0x84>
{
    80001c68:	7179                	addi	sp,sp,-48
    80001c6a:	f406                	sd	ra,40(sp)
    80001c6c:	f022                	sd	s0,32(sp)
    80001c6e:	ec26                	sd	s1,24(sp)
    80001c70:	e84a                	sd	s2,16(sp)
    80001c72:	e44e                	sd	s3,8(sp)
    80001c74:	1800                	addi	s0,sp,48
      return -1;
    pte_t *pte = walk(pagetable, va, 0);
    80001c76:	4601                	li	a2,0
    80001c78:	fffff097          	auipc	ra,0xfffff
    80001c7c:	864080e7          	jalr	-1948(ra) # 800004dc <walk>
    80001c80:	892a                	mv	s2,a0
    if (pte == 0)
    80001c82:	c13d                	beqz	a0,80001ce8 <cowhandler+0x88>
      return -1;
    // check the PTE
    if ((*pte & PTE_RSW) == 0 || (*pte & PTE_U) == 0 || (*pte & PTE_V) == 0) {
    80001c84:	611c                	ld	a5,0(a0)
    80001c86:	1117f793          	andi	a5,a5,273
    80001c8a:	11100713          	li	a4,273
    80001c8e:	04e79f63          	bne	a5,a4,80001cec <cowhandler+0x8c>
      return -1;
    }
    if ((mem = kalloc()) == 0) {
    80001c92:	ffffe097          	auipc	ra,0xffffe
    80001c96:	4cc080e7          	jalr	1228(ra) # 8000015e <kalloc>
    80001c9a:	84aa                	mv	s1,a0
    80001c9c:	c931                	beqz	a0,80001cf0 <cowhandler+0x90>
      return -1;
    }
    // old physical address
    uint64 pa = PTE2PA(*pte);
    80001c9e:	00093983          	ld	s3,0(s2)
    80001ca2:	00a9d993          	srli	s3,s3,0xa
    80001ca6:	09b2                	slli	s3,s3,0xc
    // copy old data to new mem
    memmove((char*)mem, (char*)pa, PGSIZE);
    80001ca8:	6605                	lui	a2,0x1
    80001caa:	85ce                	mv	a1,s3
    80001cac:	ffffe097          	auipc	ra,0xffffe
    80001cb0:	5a8080e7          	jalr	1448(ra) # 80000254 <memmove>
    // PAY ATTENTION
    // decrease the reference count of old memory page, because a new page has been allocated
    kfree((void*)pa);
    80001cb4:	854e                	mv	a0,s3
    80001cb6:	ffffe097          	auipc	ra,0xffffe
    80001cba:	366080e7          	jalr	870(ra) # 8000001c <kfree>
    uint flags = PTE_FLAGS(*pte);
    // set PTE_W to 1, change the address pointed to by PTE to new memory page(mem)
    *pte = (PA2PTE(mem) | flags | PTE_W);
    80001cbe:	80b1                	srli	s1,s1,0xc
    80001cc0:	04aa                	slli	s1,s1,0xa
    uint flags = PTE_FLAGS(*pte);
    80001cc2:	00093783          	ld	a5,0(s2)
    *pte = (PA2PTE(mem) | flags | PTE_W);
    80001cc6:	2ff7f793          	andi	a5,a5,767
    // set PTE_RSW to 0
    *pte &= ~PTE_RSW;
    80001cca:	8fc5                	or	a5,a5,s1
    80001ccc:	0047e793          	ori	a5,a5,4
    80001cd0:	00f93023          	sd	a5,0(s2)
    return 0;
    80001cd4:	4501                	li	a0,0
}
    80001cd6:	70a2                	ld	ra,40(sp)
    80001cd8:	7402                	ld	s0,32(sp)
    80001cda:	64e2                	ld	s1,24(sp)
    80001cdc:	6942                	ld	s2,16(sp)
    80001cde:	69a2                	ld	s3,8(sp)
    80001ce0:	6145                	addi	sp,sp,48
    80001ce2:	8082                	ret
      return -1;
    80001ce4:	557d                	li	a0,-1
}
    80001ce6:	8082                	ret
      return -1;
    80001ce8:	557d                	li	a0,-1
    80001cea:	b7f5                	j	80001cd6 <cowhandler+0x76>
      return -1;
    80001cec:	557d                	li	a0,-1
    80001cee:	b7e5                	j	80001cd6 <cowhandler+0x76>
      return -1;
    80001cf0:	557d                	li	a0,-1
    80001cf2:	b7d5                	j	80001cd6 <cowhandler+0x76>

0000000080001cf4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cf4:	1141                	addi	sp,sp,-16
    80001cf6:	e406                	sd	ra,8(sp)
    80001cf8:	e022                	sd	s0,0(sp)
    80001cfa:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cfc:	fffff097          	auipc	ra,0xfffff
    80001d00:	2ae080e7          	jalr	686(ra) # 80000faa <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d04:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d08:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d0a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d0e:	00005697          	auipc	a3,0x5
    80001d12:	2f268693          	addi	a3,a3,754 # 80007000 <_trampoline>
    80001d16:	00005717          	auipc	a4,0x5
    80001d1a:	2ea70713          	addi	a4,a4,746 # 80007000 <_trampoline>
    80001d1e:	8f15                	sub	a4,a4,a3
    80001d20:	040007b7          	lui	a5,0x4000
    80001d24:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d26:	07b2                	slli	a5,a5,0xc
    80001d28:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d2a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d2e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d30:	18002673          	csrr	a2,satp
    80001d34:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d36:	6d30                	ld	a2,88(a0)
    80001d38:	6138                	ld	a4,64(a0)
    80001d3a:	6585                	lui	a1,0x1
    80001d3c:	972e                	add	a4,a4,a1
    80001d3e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d40:	6d38                	ld	a4,88(a0)
    80001d42:	00000617          	auipc	a2,0x0
    80001d46:	13060613          	addi	a2,a2,304 # 80001e72 <usertrap>
    80001d4a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d4c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d4e:	8612                	mv	a2,tp
    80001d50:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d52:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d56:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d5a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d5e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d62:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d64:	6f18                	ld	a4,24(a4)
    80001d66:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d6a:	6928                	ld	a0,80(a0)
    80001d6c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d6e:	00005717          	auipc	a4,0x5
    80001d72:	32e70713          	addi	a4,a4,814 # 8000709c <userret>
    80001d76:	8f15                	sub	a4,a4,a3
    80001d78:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d7a:	577d                	li	a4,-1
    80001d7c:	177e                	slli	a4,a4,0x3f
    80001d7e:	8d59                	or	a0,a0,a4
    80001d80:	9782                	jalr	a5
}
    80001d82:	60a2                	ld	ra,8(sp)
    80001d84:	6402                	ld	s0,0(sp)
    80001d86:	0141                	addi	sp,sp,16
    80001d88:	8082                	ret

0000000080001d8a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d8a:	1101                	addi	sp,sp,-32
    80001d8c:	ec06                	sd	ra,24(sp)
    80001d8e:	e822                	sd	s0,16(sp)
    80001d90:	e426                	sd	s1,8(sp)
    80001d92:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d94:	0022d497          	auipc	s1,0x22d
    80001d98:	9b448493          	addi	s1,s1,-1612 # 8022e748 <tickslock>
    80001d9c:	8526                	mv	a0,s1
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	536080e7          	jalr	1334(ra) # 800062d4 <acquire>
  ticks++;
    80001da6:	00007517          	auipc	a0,0x7
    80001daa:	b2250513          	addi	a0,a0,-1246 # 800088c8 <ticks>
    80001dae:	411c                	lw	a5,0(a0)
    80001db0:	2785                	addiw	a5,a5,1
    80001db2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001db4:	00000097          	auipc	ra,0x0
    80001db8:	902080e7          	jalr	-1790(ra) # 800016b6 <wakeup>
  release(&tickslock);
    80001dbc:	8526                	mv	a0,s1
    80001dbe:	00004097          	auipc	ra,0x4
    80001dc2:	5ca080e7          	jalr	1482(ra) # 80006388 <release>
}
    80001dc6:	60e2                	ld	ra,24(sp)
    80001dc8:	6442                	ld	s0,16(sp)
    80001dca:	64a2                	ld	s1,8(sp)
    80001dcc:	6105                	addi	sp,sp,32
    80001dce:	8082                	ret

0000000080001dd0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001dd0:	1101                	addi	sp,sp,-32
    80001dd2:	ec06                	sd	ra,24(sp)
    80001dd4:	e822                	sd	s0,16(sp)
    80001dd6:	e426                	sd	s1,8(sp)
    80001dd8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dda:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001dde:	00074d63          	bltz	a4,80001df8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001de2:	57fd                	li	a5,-1
    80001de4:	17fe                	slli	a5,a5,0x3f
    80001de6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001de8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dea:	06f70363          	beq	a4,a5,80001e50 <devintr+0x80>
  }
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	64a2                	ld	s1,8(sp)
    80001df4:	6105                	addi	sp,sp,32
    80001df6:	8082                	ret
     (scause & 0xff) == 9){
    80001df8:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001dfc:	46a5                	li	a3,9
    80001dfe:	fed792e3          	bne	a5,a3,80001de2 <devintr+0x12>
    int irq = plic_claim();
    80001e02:	00003097          	auipc	ra,0x3
    80001e06:	4d6080e7          	jalr	1238(ra) # 800052d8 <plic_claim>
    80001e0a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e0c:	47a9                	li	a5,10
    80001e0e:	02f50763          	beq	a0,a5,80001e3c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e12:	4785                	li	a5,1
    80001e14:	02f50963          	beq	a0,a5,80001e46 <devintr+0x76>
    return 1;
    80001e18:	4505                	li	a0,1
    } else if(irq){
    80001e1a:	d8f1                	beqz	s1,80001dee <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e1c:	85a6                	mv	a1,s1
    80001e1e:	00006517          	auipc	a0,0x6
    80001e22:	46250513          	addi	a0,a0,1122 # 80008280 <states.0+0x38>
    80001e26:	00004097          	auipc	ra,0x4
    80001e2a:	fc0080e7          	jalr	-64(ra) # 80005de6 <printf>
      plic_complete(irq);
    80001e2e:	8526                	mv	a0,s1
    80001e30:	00003097          	auipc	ra,0x3
    80001e34:	4cc080e7          	jalr	1228(ra) # 800052fc <plic_complete>
    return 1;
    80001e38:	4505                	li	a0,1
    80001e3a:	bf55                	j	80001dee <devintr+0x1e>
      uartintr();
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	3b8080e7          	jalr	952(ra) # 800061f4 <uartintr>
    80001e44:	b7ed                	j	80001e2e <devintr+0x5e>
      virtio_disk_intr();
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	97e080e7          	jalr	-1666(ra) # 800057c4 <virtio_disk_intr>
    80001e4e:	b7c5                	j	80001e2e <devintr+0x5e>
    if(cpuid() == 0){
    80001e50:	fffff097          	auipc	ra,0xfffff
    80001e54:	12e080e7          	jalr	302(ra) # 80000f7e <cpuid>
    80001e58:	c901                	beqz	a0,80001e68 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e5a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e5e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e60:	14479073          	csrw	sip,a5
    return 2;
    80001e64:	4509                	li	a0,2
    80001e66:	b761                	j	80001dee <devintr+0x1e>
      clockintr();
    80001e68:	00000097          	auipc	ra,0x0
    80001e6c:	f22080e7          	jalr	-222(ra) # 80001d8a <clockintr>
    80001e70:	b7ed                	j	80001e5a <devintr+0x8a>

0000000080001e72 <usertrap>:
{
    80001e72:	1101                	addi	sp,sp,-32
    80001e74:	ec06                	sd	ra,24(sp)
    80001e76:	e822                	sd	s0,16(sp)
    80001e78:	e426                	sd	s1,8(sp)
    80001e7a:	e04a                	sd	s2,0(sp)
    80001e7c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e7e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e82:	1007f793          	andi	a5,a5,256
    80001e86:	ebad                	bnez	a5,80001ef8 <usertrap+0x86>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e88:	00003797          	auipc	a5,0x3
    80001e8c:	34878793          	addi	a5,a5,840 # 800051d0 <kernelvec>
    80001e90:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	116080e7          	jalr	278(ra) # 80000faa <myproc>
    80001e9c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e9e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ea0:	14102773          	csrr	a4,sepc
    80001ea4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ea6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001eaa:	47a1                	li	a5,8
    80001eac:	04f70e63          	beq	a4,a5,80001f08 <usertrap+0x96>
    80001eb0:	14202773          	csrr	a4,scause
  else if (r_scause() == 15) {
    80001eb4:	47bd                	li	a5,15
    80001eb6:	08f71363          	bne	a4,a5,80001f3c <usertrap+0xca>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eba:	143025f3          	csrr	a1,stval
    if (va >= p->sz)
    80001ebe:	653c                	ld	a5,72(a0)
    80001ec0:	00f5e463          	bltu	a1,a5,80001ec8 <usertrap+0x56>
      p->killed = 1;
    80001ec4:	4785                	li	a5,1
    80001ec6:	d51c                	sw	a5,40(a0)
    int ret = cowhandler(p->pagetable, va);
    80001ec8:	68a8                	ld	a0,80(s1)
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	d96080e7          	jalr	-618(ra) # 80001c60 <cowhandler>
    if (ret != 0)
    80001ed2:	c119                	beqz	a0,80001ed8 <usertrap+0x66>
      p->killed = 1;
    80001ed4:	4785                	li	a5,1
    80001ed6:	d49c                	sw	a5,40(s1)
  if(killed(p))
    80001ed8:	8526                	mv	a0,s1
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	a20080e7          	jalr	-1504(ra) # 800018fa <killed>
    80001ee2:	e55d                	bnez	a0,80001f90 <usertrap+0x11e>
  usertrapret();
    80001ee4:	00000097          	auipc	ra,0x0
    80001ee8:	e10080e7          	jalr	-496(ra) # 80001cf4 <usertrapret>
}
    80001eec:	60e2                	ld	ra,24(sp)
    80001eee:	6442                	ld	s0,16(sp)
    80001ef0:	64a2                	ld	s1,8(sp)
    80001ef2:	6902                	ld	s2,0(sp)
    80001ef4:	6105                	addi	sp,sp,32
    80001ef6:	8082                	ret
    panic("usertrap: not from user mode");
    80001ef8:	00006517          	auipc	a0,0x6
    80001efc:	3a850513          	addi	a0,a0,936 # 800082a0 <states.0+0x58>
    80001f00:	00004097          	auipc	ra,0x4
    80001f04:	e9c080e7          	jalr	-356(ra) # 80005d9c <panic>
    if(killed(p))
    80001f08:	00000097          	auipc	ra,0x0
    80001f0c:	9f2080e7          	jalr	-1550(ra) # 800018fa <killed>
    80001f10:	e105                	bnez	a0,80001f30 <usertrap+0xbe>
    p->trapframe->epc += 4;
    80001f12:	6cb8                	ld	a4,88(s1)
    80001f14:	6f1c                	ld	a5,24(a4)
    80001f16:	0791                	addi	a5,a5,4
    80001f18:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f1e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f22:	10079073          	csrw	sstatus,a5
    syscall();
    80001f26:	00000097          	auipc	ra,0x0
    80001f2a:	2d0080e7          	jalr	720(ra) # 800021f6 <syscall>
    80001f2e:	b76d                	j	80001ed8 <usertrap+0x66>
      exit(-1);
    80001f30:	557d                	li	a0,-1
    80001f32:	00000097          	auipc	ra,0x0
    80001f36:	854080e7          	jalr	-1964(ra) # 80001786 <exit>
    80001f3a:	bfe1                	j	80001f12 <usertrap+0xa0>
  } else if((which_dev = devintr()) != 0){
    80001f3c:	00000097          	auipc	ra,0x0
    80001f40:	e94080e7          	jalr	-364(ra) # 80001dd0 <devintr>
    80001f44:	892a                	mv	s2,a0
    80001f46:	c901                	beqz	a0,80001f56 <usertrap+0xe4>
  if(killed(p))
    80001f48:	8526                	mv	a0,s1
    80001f4a:	00000097          	auipc	ra,0x0
    80001f4e:	9b0080e7          	jalr	-1616(ra) # 800018fa <killed>
    80001f52:	c529                	beqz	a0,80001f9c <usertrap+0x12a>
    80001f54:	a83d                	j	80001f92 <usertrap+0x120>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f56:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f5a:	5890                	lw	a2,48(s1)
    80001f5c:	00006517          	auipc	a0,0x6
    80001f60:	36450513          	addi	a0,a0,868 # 800082c0 <states.0+0x78>
    80001f64:	00004097          	auipc	ra,0x4
    80001f68:	e82080e7          	jalr	-382(ra) # 80005de6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f6c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f70:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f74:	00006517          	auipc	a0,0x6
    80001f78:	37c50513          	addi	a0,a0,892 # 800082f0 <states.0+0xa8>
    80001f7c:	00004097          	auipc	ra,0x4
    80001f80:	e6a080e7          	jalr	-406(ra) # 80005de6 <printf>
    setkilled(p);
    80001f84:	8526                	mv	a0,s1
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	948080e7          	jalr	-1720(ra) # 800018ce <setkilled>
    80001f8e:	b7a9                	j	80001ed8 <usertrap+0x66>
  if(killed(p))
    80001f90:	4901                	li	s2,0
    exit(-1);
    80001f92:	557d                	li	a0,-1
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	7f2080e7          	jalr	2034(ra) # 80001786 <exit>
  if(which_dev == 2)
    80001f9c:	4789                	li	a5,2
    80001f9e:	f4f913e3          	bne	s2,a5,80001ee4 <usertrap+0x72>
    yield();
    80001fa2:	fffff097          	auipc	ra,0xfffff
    80001fa6:	674080e7          	jalr	1652(ra) # 80001616 <yield>
    80001faa:	bf2d                	j	80001ee4 <usertrap+0x72>

0000000080001fac <kerneltrap>:
{
    80001fac:	7179                	addi	sp,sp,-48
    80001fae:	f406                	sd	ra,40(sp)
    80001fb0:	f022                	sd	s0,32(sp)
    80001fb2:	ec26                	sd	s1,24(sp)
    80001fb4:	e84a                	sd	s2,16(sp)
    80001fb6:	e44e                	sd	s3,8(sp)
    80001fb8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fba:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fbe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fc2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fc6:	1004f793          	andi	a5,s1,256
    80001fca:	cb85                	beqz	a5,80001ffa <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fcc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fd0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fd2:	ef85                	bnez	a5,8000200a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fd4:	00000097          	auipc	ra,0x0
    80001fd8:	dfc080e7          	jalr	-516(ra) # 80001dd0 <devintr>
    80001fdc:	cd1d                	beqz	a0,8000201a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fde:	4789                	li	a5,2
    80001fe0:	06f50a63          	beq	a0,a5,80002054 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fe4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fe8:	10049073          	csrw	sstatus,s1
}
    80001fec:	70a2                	ld	ra,40(sp)
    80001fee:	7402                	ld	s0,32(sp)
    80001ff0:	64e2                	ld	s1,24(sp)
    80001ff2:	6942                	ld	s2,16(sp)
    80001ff4:	69a2                	ld	s3,8(sp)
    80001ff6:	6145                	addi	sp,sp,48
    80001ff8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	31650513          	addi	a0,a0,790 # 80008310 <states.0+0xc8>
    80002002:	00004097          	auipc	ra,0x4
    80002006:	d9a080e7          	jalr	-614(ra) # 80005d9c <panic>
    panic("kerneltrap: interrupts enabled");
    8000200a:	00006517          	auipc	a0,0x6
    8000200e:	32e50513          	addi	a0,a0,814 # 80008338 <states.0+0xf0>
    80002012:	00004097          	auipc	ra,0x4
    80002016:	d8a080e7          	jalr	-630(ra) # 80005d9c <panic>
    printf("scause %p\n", scause);
    8000201a:	85ce                	mv	a1,s3
    8000201c:	00006517          	auipc	a0,0x6
    80002020:	33c50513          	addi	a0,a0,828 # 80008358 <states.0+0x110>
    80002024:	00004097          	auipc	ra,0x4
    80002028:	dc2080e7          	jalr	-574(ra) # 80005de6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000202c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002030:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002034:	00006517          	auipc	a0,0x6
    80002038:	33450513          	addi	a0,a0,820 # 80008368 <states.0+0x120>
    8000203c:	00004097          	auipc	ra,0x4
    80002040:	daa080e7          	jalr	-598(ra) # 80005de6 <printf>
    panic("kerneltrap");
    80002044:	00006517          	auipc	a0,0x6
    80002048:	33c50513          	addi	a0,a0,828 # 80008380 <states.0+0x138>
    8000204c:	00004097          	auipc	ra,0x4
    80002050:	d50080e7          	jalr	-688(ra) # 80005d9c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002054:	fffff097          	auipc	ra,0xfffff
    80002058:	f56080e7          	jalr	-170(ra) # 80000faa <myproc>
    8000205c:	d541                	beqz	a0,80001fe4 <kerneltrap+0x38>
    8000205e:	fffff097          	auipc	ra,0xfffff
    80002062:	f4c080e7          	jalr	-180(ra) # 80000faa <myproc>
    80002066:	4d18                	lw	a4,24(a0)
    80002068:	4791                	li	a5,4
    8000206a:	f6f71de3          	bne	a4,a5,80001fe4 <kerneltrap+0x38>
    yield();
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	5a8080e7          	jalr	1448(ra) # 80001616 <yield>
    80002076:	b7bd                	j	80001fe4 <kerneltrap+0x38>

0000000080002078 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002078:	1101                	addi	sp,sp,-32
    8000207a:	ec06                	sd	ra,24(sp)
    8000207c:	e822                	sd	s0,16(sp)
    8000207e:	e426                	sd	s1,8(sp)
    80002080:	1000                	addi	s0,sp,32
    80002082:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	f26080e7          	jalr	-218(ra) # 80000faa <myproc>
  switch (n) {
    8000208c:	4795                	li	a5,5
    8000208e:	0497e163          	bltu	a5,s1,800020d0 <argraw+0x58>
    80002092:	048a                	slli	s1,s1,0x2
    80002094:	00006717          	auipc	a4,0x6
    80002098:	32470713          	addi	a4,a4,804 # 800083b8 <states.0+0x170>
    8000209c:	94ba                	add	s1,s1,a4
    8000209e:	409c                	lw	a5,0(s1)
    800020a0:	97ba                	add	a5,a5,a4
    800020a2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020a4:	6d3c                	ld	a5,88(a0)
    800020a6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020a8:	60e2                	ld	ra,24(sp)
    800020aa:	6442                	ld	s0,16(sp)
    800020ac:	64a2                	ld	s1,8(sp)
    800020ae:	6105                	addi	sp,sp,32
    800020b0:	8082                	ret
    return p->trapframe->a1;
    800020b2:	6d3c                	ld	a5,88(a0)
    800020b4:	7fa8                	ld	a0,120(a5)
    800020b6:	bfcd                	j	800020a8 <argraw+0x30>
    return p->trapframe->a2;
    800020b8:	6d3c                	ld	a5,88(a0)
    800020ba:	63c8                	ld	a0,128(a5)
    800020bc:	b7f5                	j	800020a8 <argraw+0x30>
    return p->trapframe->a3;
    800020be:	6d3c                	ld	a5,88(a0)
    800020c0:	67c8                	ld	a0,136(a5)
    800020c2:	b7dd                	j	800020a8 <argraw+0x30>
    return p->trapframe->a4;
    800020c4:	6d3c                	ld	a5,88(a0)
    800020c6:	6bc8                	ld	a0,144(a5)
    800020c8:	b7c5                	j	800020a8 <argraw+0x30>
    return p->trapframe->a5;
    800020ca:	6d3c                	ld	a5,88(a0)
    800020cc:	6fc8                	ld	a0,152(a5)
    800020ce:	bfe9                	j	800020a8 <argraw+0x30>
  panic("argraw");
    800020d0:	00006517          	auipc	a0,0x6
    800020d4:	2c050513          	addi	a0,a0,704 # 80008390 <states.0+0x148>
    800020d8:	00004097          	auipc	ra,0x4
    800020dc:	cc4080e7          	jalr	-828(ra) # 80005d9c <panic>

00000000800020e0 <fetchaddr>:
{
    800020e0:	1101                	addi	sp,sp,-32
    800020e2:	ec06                	sd	ra,24(sp)
    800020e4:	e822                	sd	s0,16(sp)
    800020e6:	e426                	sd	s1,8(sp)
    800020e8:	e04a                	sd	s2,0(sp)
    800020ea:	1000                	addi	s0,sp,32
    800020ec:	84aa                	mv	s1,a0
    800020ee:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	eba080e7          	jalr	-326(ra) # 80000faa <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800020f8:	653c                	ld	a5,72(a0)
    800020fa:	02f4f863          	bgeu	s1,a5,8000212a <fetchaddr+0x4a>
    800020fe:	00848713          	addi	a4,s1,8
    80002102:	02e7e663          	bltu	a5,a4,8000212e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002106:	46a1                	li	a3,8
    80002108:	8626                	mv	a2,s1
    8000210a:	85ca                	mv	a1,s2
    8000210c:	6928                	ld	a0,80(a0)
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	bec080e7          	jalr	-1044(ra) # 80000cfa <copyin>
    80002116:	00a03533          	snez	a0,a0
    8000211a:	40a00533          	neg	a0,a0
}
    8000211e:	60e2                	ld	ra,24(sp)
    80002120:	6442                	ld	s0,16(sp)
    80002122:	64a2                	ld	s1,8(sp)
    80002124:	6902                	ld	s2,0(sp)
    80002126:	6105                	addi	sp,sp,32
    80002128:	8082                	ret
    return -1;
    8000212a:	557d                	li	a0,-1
    8000212c:	bfcd                	j	8000211e <fetchaddr+0x3e>
    8000212e:	557d                	li	a0,-1
    80002130:	b7fd                	j	8000211e <fetchaddr+0x3e>

0000000080002132 <fetchstr>:
{
    80002132:	7179                	addi	sp,sp,-48
    80002134:	f406                	sd	ra,40(sp)
    80002136:	f022                	sd	s0,32(sp)
    80002138:	ec26                	sd	s1,24(sp)
    8000213a:	e84a                	sd	s2,16(sp)
    8000213c:	e44e                	sd	s3,8(sp)
    8000213e:	1800                	addi	s0,sp,48
    80002140:	892a                	mv	s2,a0
    80002142:	84ae                	mv	s1,a1
    80002144:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	e64080e7          	jalr	-412(ra) # 80000faa <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000214e:	86ce                	mv	a3,s3
    80002150:	864a                	mv	a2,s2
    80002152:	85a6                	mv	a1,s1
    80002154:	6928                	ld	a0,80(a0)
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	c32080e7          	jalr	-974(ra) # 80000d88 <copyinstr>
    8000215e:	00054e63          	bltz	a0,8000217a <fetchstr+0x48>
  return strlen(buf);
    80002162:	8526                	mv	a0,s1
    80002164:	ffffe097          	auipc	ra,0xffffe
    80002168:	210080e7          	jalr	528(ra) # 80000374 <strlen>
}
    8000216c:	70a2                	ld	ra,40(sp)
    8000216e:	7402                	ld	s0,32(sp)
    80002170:	64e2                	ld	s1,24(sp)
    80002172:	6942                	ld	s2,16(sp)
    80002174:	69a2                	ld	s3,8(sp)
    80002176:	6145                	addi	sp,sp,48
    80002178:	8082                	ret
    return -1;
    8000217a:	557d                	li	a0,-1
    8000217c:	bfc5                	j	8000216c <fetchstr+0x3a>

000000008000217e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000217e:	1101                	addi	sp,sp,-32
    80002180:	ec06                	sd	ra,24(sp)
    80002182:	e822                	sd	s0,16(sp)
    80002184:	e426                	sd	s1,8(sp)
    80002186:	1000                	addi	s0,sp,32
    80002188:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	eee080e7          	jalr	-274(ra) # 80002078 <argraw>
    80002192:	c088                	sw	a0,0(s1)
}
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	64a2                	ld	s1,8(sp)
    8000219a:	6105                	addi	sp,sp,32
    8000219c:	8082                	ret

000000008000219e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000219e:	1101                	addi	sp,sp,-32
    800021a0:	ec06                	sd	ra,24(sp)
    800021a2:	e822                	sd	s0,16(sp)
    800021a4:	e426                	sd	s1,8(sp)
    800021a6:	1000                	addi	s0,sp,32
    800021a8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021aa:	00000097          	auipc	ra,0x0
    800021ae:	ece080e7          	jalr	-306(ra) # 80002078 <argraw>
    800021b2:	e088                	sd	a0,0(s1)
}
    800021b4:	60e2                	ld	ra,24(sp)
    800021b6:	6442                	ld	s0,16(sp)
    800021b8:	64a2                	ld	s1,8(sp)
    800021ba:	6105                	addi	sp,sp,32
    800021bc:	8082                	ret

00000000800021be <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021be:	7179                	addi	sp,sp,-48
    800021c0:	f406                	sd	ra,40(sp)
    800021c2:	f022                	sd	s0,32(sp)
    800021c4:	ec26                	sd	s1,24(sp)
    800021c6:	e84a                	sd	s2,16(sp)
    800021c8:	1800                	addi	s0,sp,48
    800021ca:	84ae                	mv	s1,a1
    800021cc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800021ce:	fd840593          	addi	a1,s0,-40
    800021d2:	00000097          	auipc	ra,0x0
    800021d6:	fcc080e7          	jalr	-52(ra) # 8000219e <argaddr>
  return fetchstr(addr, buf, max);
    800021da:	864a                	mv	a2,s2
    800021dc:	85a6                	mv	a1,s1
    800021de:	fd843503          	ld	a0,-40(s0)
    800021e2:	00000097          	auipc	ra,0x0
    800021e6:	f50080e7          	jalr	-176(ra) # 80002132 <fetchstr>
}
    800021ea:	70a2                	ld	ra,40(sp)
    800021ec:	7402                	ld	s0,32(sp)
    800021ee:	64e2                	ld	s1,24(sp)
    800021f0:	6942                	ld	s2,16(sp)
    800021f2:	6145                	addi	sp,sp,48
    800021f4:	8082                	ret

00000000800021f6 <syscall>:



void
syscall(void)
{
    800021f6:	1101                	addi	sp,sp,-32
    800021f8:	ec06                	sd	ra,24(sp)
    800021fa:	e822                	sd	s0,16(sp)
    800021fc:	e426                	sd	s1,8(sp)
    800021fe:	e04a                	sd	s2,0(sp)
    80002200:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	da8080e7          	jalr	-600(ra) # 80000faa <myproc>
    8000220a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000220c:	05853903          	ld	s2,88(a0)
    80002210:	0a893783          	ld	a5,168(s2)
    80002214:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002218:	37fd                	addiw	a5,a5,-1
    8000221a:	4751                	li	a4,20
    8000221c:	00f76f63          	bltu	a4,a5,8000223a <syscall+0x44>
    80002220:	00369713          	slli	a4,a3,0x3
    80002224:	00006797          	auipc	a5,0x6
    80002228:	1ac78793          	addi	a5,a5,428 # 800083d0 <syscalls>
    8000222c:	97ba                	add	a5,a5,a4
    8000222e:	639c                	ld	a5,0(a5)
    80002230:	c789                	beqz	a5,8000223a <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002232:	9782                	jalr	a5
    80002234:	06a93823          	sd	a0,112(s2)
    80002238:	a839                	j	80002256 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000223a:	15848613          	addi	a2,s1,344
    8000223e:	588c                	lw	a1,48(s1)
    80002240:	00006517          	auipc	a0,0x6
    80002244:	15850513          	addi	a0,a0,344 # 80008398 <states.0+0x150>
    80002248:	00004097          	auipc	ra,0x4
    8000224c:	b9e080e7          	jalr	-1122(ra) # 80005de6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002250:	6cbc                	ld	a5,88(s1)
    80002252:	577d                	li	a4,-1
    80002254:	fbb8                	sd	a4,112(a5)
  }
}
    80002256:	60e2                	ld	ra,24(sp)
    80002258:	6442                	ld	s0,16(sp)
    8000225a:	64a2                	ld	s1,8(sp)
    8000225c:	6902                	ld	s2,0(sp)
    8000225e:	6105                	addi	sp,sp,32
    80002260:	8082                	ret

0000000080002262 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002262:	1101                	addi	sp,sp,-32
    80002264:	ec06                	sd	ra,24(sp)
    80002266:	e822                	sd	s0,16(sp)
    80002268:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000226a:	fec40593          	addi	a1,s0,-20
    8000226e:	4501                	li	a0,0
    80002270:	00000097          	auipc	ra,0x0
    80002274:	f0e080e7          	jalr	-242(ra) # 8000217e <argint>
  exit(n);
    80002278:	fec42503          	lw	a0,-20(s0)
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	50a080e7          	jalr	1290(ra) # 80001786 <exit>
  return 0;  // not reached
}
    80002284:	4501                	li	a0,0
    80002286:	60e2                	ld	ra,24(sp)
    80002288:	6442                	ld	s0,16(sp)
    8000228a:	6105                	addi	sp,sp,32
    8000228c:	8082                	ret

000000008000228e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000228e:	1141                	addi	sp,sp,-16
    80002290:	e406                	sd	ra,8(sp)
    80002292:	e022                	sd	s0,0(sp)
    80002294:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002296:	fffff097          	auipc	ra,0xfffff
    8000229a:	d14080e7          	jalr	-748(ra) # 80000faa <myproc>
}
    8000229e:	5908                	lw	a0,48(a0)
    800022a0:	60a2                	ld	ra,8(sp)
    800022a2:	6402                	ld	s0,0(sp)
    800022a4:	0141                	addi	sp,sp,16
    800022a6:	8082                	ret

00000000800022a8 <sys_fork>:

uint64
sys_fork(void)
{
    800022a8:	1141                	addi	sp,sp,-16
    800022aa:	e406                	sd	ra,8(sp)
    800022ac:	e022                	sd	s0,0(sp)
    800022ae:	0800                	addi	s0,sp,16
  return fork();
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	0b0080e7          	jalr	176(ra) # 80001360 <fork>
}
    800022b8:	60a2                	ld	ra,8(sp)
    800022ba:	6402                	ld	s0,0(sp)
    800022bc:	0141                	addi	sp,sp,16
    800022be:	8082                	ret

00000000800022c0 <sys_wait>:

uint64
sys_wait(void)
{
    800022c0:	1101                	addi	sp,sp,-32
    800022c2:	ec06                	sd	ra,24(sp)
    800022c4:	e822                	sd	s0,16(sp)
    800022c6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800022c8:	fe840593          	addi	a1,s0,-24
    800022cc:	4501                	li	a0,0
    800022ce:	00000097          	auipc	ra,0x0
    800022d2:	ed0080e7          	jalr	-304(ra) # 8000219e <argaddr>
  return wait(p);
    800022d6:	fe843503          	ld	a0,-24(s0)
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	652080e7          	jalr	1618(ra) # 8000192c <wait>
}
    800022e2:	60e2                	ld	ra,24(sp)
    800022e4:	6442                	ld	s0,16(sp)
    800022e6:	6105                	addi	sp,sp,32
    800022e8:	8082                	ret

00000000800022ea <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022ea:	7179                	addi	sp,sp,-48
    800022ec:	f406                	sd	ra,40(sp)
    800022ee:	f022                	sd	s0,32(sp)
    800022f0:	ec26                	sd	s1,24(sp)
    800022f2:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800022f4:	fdc40593          	addi	a1,s0,-36
    800022f8:	4501                	li	a0,0
    800022fa:	00000097          	auipc	ra,0x0
    800022fe:	e84080e7          	jalr	-380(ra) # 8000217e <argint>
  addr = myproc()->sz;
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	ca8080e7          	jalr	-856(ra) # 80000faa <myproc>
    8000230a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000230c:	fdc42503          	lw	a0,-36(s0)
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	ff4080e7          	jalr	-12(ra) # 80001304 <growproc>
    80002318:	00054863          	bltz	a0,80002328 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000231c:	8526                	mv	a0,s1
    8000231e:	70a2                	ld	ra,40(sp)
    80002320:	7402                	ld	s0,32(sp)
    80002322:	64e2                	ld	s1,24(sp)
    80002324:	6145                	addi	sp,sp,48
    80002326:	8082                	ret
    return -1;
    80002328:	54fd                	li	s1,-1
    8000232a:	bfcd                	j	8000231c <sys_sbrk+0x32>

000000008000232c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000232c:	7139                	addi	sp,sp,-64
    8000232e:	fc06                	sd	ra,56(sp)
    80002330:	f822                	sd	s0,48(sp)
    80002332:	f426                	sd	s1,40(sp)
    80002334:	f04a                	sd	s2,32(sp)
    80002336:	ec4e                	sd	s3,24(sp)
    80002338:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    8000233a:	fcc40593          	addi	a1,s0,-52
    8000233e:	4501                	li	a0,0
    80002340:	00000097          	auipc	ra,0x0
    80002344:	e3e080e7          	jalr	-450(ra) # 8000217e <argint>
  acquire(&tickslock);
    80002348:	0022c517          	auipc	a0,0x22c
    8000234c:	40050513          	addi	a0,a0,1024 # 8022e748 <tickslock>
    80002350:	00004097          	auipc	ra,0x4
    80002354:	f84080e7          	jalr	-124(ra) # 800062d4 <acquire>
  ticks0 = ticks;
    80002358:	00006917          	auipc	s2,0x6
    8000235c:	57092903          	lw	s2,1392(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    80002360:	fcc42783          	lw	a5,-52(s0)
    80002364:	cf9d                	beqz	a5,800023a2 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002366:	0022c997          	auipc	s3,0x22c
    8000236a:	3e298993          	addi	s3,s3,994 # 8022e748 <tickslock>
    8000236e:	00006497          	auipc	s1,0x6
    80002372:	55a48493          	addi	s1,s1,1370 # 800088c8 <ticks>
    if(killed(myproc())){
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	c34080e7          	jalr	-972(ra) # 80000faa <myproc>
    8000237e:	fffff097          	auipc	ra,0xfffff
    80002382:	57c080e7          	jalr	1404(ra) # 800018fa <killed>
    80002386:	ed15                	bnez	a0,800023c2 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002388:	85ce                	mv	a1,s3
    8000238a:	8526                	mv	a0,s1
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	2c6080e7          	jalr	710(ra) # 80001652 <sleep>
  while(ticks - ticks0 < n){
    80002394:	409c                	lw	a5,0(s1)
    80002396:	412787bb          	subw	a5,a5,s2
    8000239a:	fcc42703          	lw	a4,-52(s0)
    8000239e:	fce7ece3          	bltu	a5,a4,80002376 <sys_sleep+0x4a>
  }
  release(&tickslock);
    800023a2:	0022c517          	auipc	a0,0x22c
    800023a6:	3a650513          	addi	a0,a0,934 # 8022e748 <tickslock>
    800023aa:	00004097          	auipc	ra,0x4
    800023ae:	fde080e7          	jalr	-34(ra) # 80006388 <release>
  return 0;
    800023b2:	4501                	li	a0,0
}
    800023b4:	70e2                	ld	ra,56(sp)
    800023b6:	7442                	ld	s0,48(sp)
    800023b8:	74a2                	ld	s1,40(sp)
    800023ba:	7902                	ld	s2,32(sp)
    800023bc:	69e2                	ld	s3,24(sp)
    800023be:	6121                	addi	sp,sp,64
    800023c0:	8082                	ret
      release(&tickslock);
    800023c2:	0022c517          	auipc	a0,0x22c
    800023c6:	38650513          	addi	a0,a0,902 # 8022e748 <tickslock>
    800023ca:	00004097          	auipc	ra,0x4
    800023ce:	fbe080e7          	jalr	-66(ra) # 80006388 <release>
      return -1;
    800023d2:	557d                	li	a0,-1
    800023d4:	b7c5                	j	800023b4 <sys_sleep+0x88>

00000000800023d6 <sys_kill>:
}
#endif

uint64
sys_kill(void)
{
    800023d6:	1101                	addi	sp,sp,-32
    800023d8:	ec06                	sd	ra,24(sp)
    800023da:	e822                	sd	s0,16(sp)
    800023dc:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800023de:	fec40593          	addi	a1,s0,-20
    800023e2:	4501                	li	a0,0
    800023e4:	00000097          	auipc	ra,0x0
    800023e8:	d9a080e7          	jalr	-614(ra) # 8000217e <argint>
  return kill(pid);
    800023ec:	fec42503          	lw	a0,-20(s0)
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	46c080e7          	jalr	1132(ra) # 8000185c <kill>
}
    800023f8:	60e2                	ld	ra,24(sp)
    800023fa:	6442                	ld	s0,16(sp)
    800023fc:	6105                	addi	sp,sp,32
    800023fe:	8082                	ret

0000000080002400 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002400:	1101                	addi	sp,sp,-32
    80002402:	ec06                	sd	ra,24(sp)
    80002404:	e822                	sd	s0,16(sp)
    80002406:	e426                	sd	s1,8(sp)
    80002408:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000240a:	0022c517          	auipc	a0,0x22c
    8000240e:	33e50513          	addi	a0,a0,830 # 8022e748 <tickslock>
    80002412:	00004097          	auipc	ra,0x4
    80002416:	ec2080e7          	jalr	-318(ra) # 800062d4 <acquire>
  xticks = ticks;
    8000241a:	00006497          	auipc	s1,0x6
    8000241e:	4ae4a483          	lw	s1,1198(s1) # 800088c8 <ticks>
  release(&tickslock);
    80002422:	0022c517          	auipc	a0,0x22c
    80002426:	32650513          	addi	a0,a0,806 # 8022e748 <tickslock>
    8000242a:	00004097          	auipc	ra,0x4
    8000242e:	f5e080e7          	jalr	-162(ra) # 80006388 <release>
  return xticks;
}
    80002432:	02049513          	slli	a0,s1,0x20
    80002436:	9101                	srli	a0,a0,0x20
    80002438:	60e2                	ld	ra,24(sp)
    8000243a:	6442                	ld	s0,16(sp)
    8000243c:	64a2                	ld	s1,8(sp)
    8000243e:	6105                	addi	sp,sp,32
    80002440:	8082                	ret

0000000080002442 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002442:	7179                	addi	sp,sp,-48
    80002444:	f406                	sd	ra,40(sp)
    80002446:	f022                	sd	s0,32(sp)
    80002448:	ec26                	sd	s1,24(sp)
    8000244a:	e84a                	sd	s2,16(sp)
    8000244c:	e44e                	sd	s3,8(sp)
    8000244e:	e052                	sd	s4,0(sp)
    80002450:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002452:	00006597          	auipc	a1,0x6
    80002456:	02e58593          	addi	a1,a1,46 # 80008480 <syscalls+0xb0>
    8000245a:	0022c517          	auipc	a0,0x22c
    8000245e:	30650513          	addi	a0,a0,774 # 8022e760 <bcache>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	de2080e7          	jalr	-542(ra) # 80006244 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000246a:	00234797          	auipc	a5,0x234
    8000246e:	2f678793          	addi	a5,a5,758 # 80236760 <bcache+0x8000>
    80002472:	00234717          	auipc	a4,0x234
    80002476:	55670713          	addi	a4,a4,1366 # 802369c8 <bcache+0x8268>
    8000247a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000247e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002482:	0022c497          	auipc	s1,0x22c
    80002486:	2f648493          	addi	s1,s1,758 # 8022e778 <bcache+0x18>
    b->next = bcache.head.next;
    8000248a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000248c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000248e:	00006a17          	auipc	s4,0x6
    80002492:	ffaa0a13          	addi	s4,s4,-6 # 80008488 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002496:	2b893783          	ld	a5,696(s2)
    8000249a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000249c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024a0:	85d2                	mv	a1,s4
    800024a2:	01048513          	addi	a0,s1,16
    800024a6:	00001097          	auipc	ra,0x1
    800024aa:	4c8080e7          	jalr	1224(ra) # 8000396e <initsleeplock>
    bcache.head.next->prev = b;
    800024ae:	2b893783          	ld	a5,696(s2)
    800024b2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024b4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024b8:	45848493          	addi	s1,s1,1112
    800024bc:	fd349de3          	bne	s1,s3,80002496 <binit+0x54>
  }
}
    800024c0:	70a2                	ld	ra,40(sp)
    800024c2:	7402                	ld	s0,32(sp)
    800024c4:	64e2                	ld	s1,24(sp)
    800024c6:	6942                	ld	s2,16(sp)
    800024c8:	69a2                	ld	s3,8(sp)
    800024ca:	6a02                	ld	s4,0(sp)
    800024cc:	6145                	addi	sp,sp,48
    800024ce:	8082                	ret

00000000800024d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024d0:	7179                	addi	sp,sp,-48
    800024d2:	f406                	sd	ra,40(sp)
    800024d4:	f022                	sd	s0,32(sp)
    800024d6:	ec26                	sd	s1,24(sp)
    800024d8:	e84a                	sd	s2,16(sp)
    800024da:	e44e                	sd	s3,8(sp)
    800024dc:	1800                	addi	s0,sp,48
    800024de:	892a                	mv	s2,a0
    800024e0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800024e2:	0022c517          	auipc	a0,0x22c
    800024e6:	27e50513          	addi	a0,a0,638 # 8022e760 <bcache>
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	dea080e7          	jalr	-534(ra) # 800062d4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024f2:	00234497          	auipc	s1,0x234
    800024f6:	5264b483          	ld	s1,1318(s1) # 80236a18 <bcache+0x82b8>
    800024fa:	00234797          	auipc	a5,0x234
    800024fe:	4ce78793          	addi	a5,a5,1230 # 802369c8 <bcache+0x8268>
    80002502:	02f48f63          	beq	s1,a5,80002540 <bread+0x70>
    80002506:	873e                	mv	a4,a5
    80002508:	a021                	j	80002510 <bread+0x40>
    8000250a:	68a4                	ld	s1,80(s1)
    8000250c:	02e48a63          	beq	s1,a4,80002540 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002510:	449c                	lw	a5,8(s1)
    80002512:	ff279ce3          	bne	a5,s2,8000250a <bread+0x3a>
    80002516:	44dc                	lw	a5,12(s1)
    80002518:	ff3799e3          	bne	a5,s3,8000250a <bread+0x3a>
      b->refcnt++;
    8000251c:	40bc                	lw	a5,64(s1)
    8000251e:	2785                	addiw	a5,a5,1
    80002520:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002522:	0022c517          	auipc	a0,0x22c
    80002526:	23e50513          	addi	a0,a0,574 # 8022e760 <bcache>
    8000252a:	00004097          	auipc	ra,0x4
    8000252e:	e5e080e7          	jalr	-418(ra) # 80006388 <release>
      acquiresleep(&b->lock);
    80002532:	01048513          	addi	a0,s1,16
    80002536:	00001097          	auipc	ra,0x1
    8000253a:	472080e7          	jalr	1138(ra) # 800039a8 <acquiresleep>
      return b;
    8000253e:	a8b9                	j	8000259c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002540:	00234497          	auipc	s1,0x234
    80002544:	4d04b483          	ld	s1,1232(s1) # 80236a10 <bcache+0x82b0>
    80002548:	00234797          	auipc	a5,0x234
    8000254c:	48078793          	addi	a5,a5,1152 # 802369c8 <bcache+0x8268>
    80002550:	00f48863          	beq	s1,a5,80002560 <bread+0x90>
    80002554:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002556:	40bc                	lw	a5,64(s1)
    80002558:	cf81                	beqz	a5,80002570 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000255a:	64a4                	ld	s1,72(s1)
    8000255c:	fee49de3          	bne	s1,a4,80002556 <bread+0x86>
  panic("bget: no buffers");
    80002560:	00006517          	auipc	a0,0x6
    80002564:	f3050513          	addi	a0,a0,-208 # 80008490 <syscalls+0xc0>
    80002568:	00004097          	auipc	ra,0x4
    8000256c:	834080e7          	jalr	-1996(ra) # 80005d9c <panic>
      b->dev = dev;
    80002570:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002574:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002578:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000257c:	4785                	li	a5,1
    8000257e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002580:	0022c517          	auipc	a0,0x22c
    80002584:	1e050513          	addi	a0,a0,480 # 8022e760 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	e00080e7          	jalr	-512(ra) # 80006388 <release>
      acquiresleep(&b->lock);
    80002590:	01048513          	addi	a0,s1,16
    80002594:	00001097          	auipc	ra,0x1
    80002598:	414080e7          	jalr	1044(ra) # 800039a8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000259c:	409c                	lw	a5,0(s1)
    8000259e:	cb89                	beqz	a5,800025b0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025a0:	8526                	mv	a0,s1
    800025a2:	70a2                	ld	ra,40(sp)
    800025a4:	7402                	ld	s0,32(sp)
    800025a6:	64e2                	ld	s1,24(sp)
    800025a8:	6942                	ld	s2,16(sp)
    800025aa:	69a2                	ld	s3,8(sp)
    800025ac:	6145                	addi	sp,sp,48
    800025ae:	8082                	ret
    virtio_disk_rw(b, 0);
    800025b0:	4581                	li	a1,0
    800025b2:	8526                	mv	a0,s1
    800025b4:	00003097          	auipc	ra,0x3
    800025b8:	fde080e7          	jalr	-34(ra) # 80005592 <virtio_disk_rw>
    b->valid = 1;
    800025bc:	4785                	li	a5,1
    800025be:	c09c                	sw	a5,0(s1)
  return b;
    800025c0:	b7c5                	j	800025a0 <bread+0xd0>

00000000800025c2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025c2:	1101                	addi	sp,sp,-32
    800025c4:	ec06                	sd	ra,24(sp)
    800025c6:	e822                	sd	s0,16(sp)
    800025c8:	e426                	sd	s1,8(sp)
    800025ca:	1000                	addi	s0,sp,32
    800025cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025ce:	0541                	addi	a0,a0,16
    800025d0:	00001097          	auipc	ra,0x1
    800025d4:	472080e7          	jalr	1138(ra) # 80003a42 <holdingsleep>
    800025d8:	cd01                	beqz	a0,800025f0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025da:	4585                	li	a1,1
    800025dc:	8526                	mv	a0,s1
    800025de:	00003097          	auipc	ra,0x3
    800025e2:	fb4080e7          	jalr	-76(ra) # 80005592 <virtio_disk_rw>
}
    800025e6:	60e2                	ld	ra,24(sp)
    800025e8:	6442                	ld	s0,16(sp)
    800025ea:	64a2                	ld	s1,8(sp)
    800025ec:	6105                	addi	sp,sp,32
    800025ee:	8082                	ret
    panic("bwrite");
    800025f0:	00006517          	auipc	a0,0x6
    800025f4:	eb850513          	addi	a0,a0,-328 # 800084a8 <syscalls+0xd8>
    800025f8:	00003097          	auipc	ra,0x3
    800025fc:	7a4080e7          	jalr	1956(ra) # 80005d9c <panic>

0000000080002600 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	e04a                	sd	s2,0(sp)
    8000260a:	1000                	addi	s0,sp,32
    8000260c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000260e:	01050913          	addi	s2,a0,16
    80002612:	854a                	mv	a0,s2
    80002614:	00001097          	auipc	ra,0x1
    80002618:	42e080e7          	jalr	1070(ra) # 80003a42 <holdingsleep>
    8000261c:	c92d                	beqz	a0,8000268e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000261e:	854a                	mv	a0,s2
    80002620:	00001097          	auipc	ra,0x1
    80002624:	3de080e7          	jalr	990(ra) # 800039fe <releasesleep>

  acquire(&bcache.lock);
    80002628:	0022c517          	auipc	a0,0x22c
    8000262c:	13850513          	addi	a0,a0,312 # 8022e760 <bcache>
    80002630:	00004097          	auipc	ra,0x4
    80002634:	ca4080e7          	jalr	-860(ra) # 800062d4 <acquire>
  b->refcnt--;
    80002638:	40bc                	lw	a5,64(s1)
    8000263a:	37fd                	addiw	a5,a5,-1
    8000263c:	0007871b          	sext.w	a4,a5
    80002640:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002642:	eb05                	bnez	a4,80002672 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002644:	68bc                	ld	a5,80(s1)
    80002646:	64b8                	ld	a4,72(s1)
    80002648:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000264a:	64bc                	ld	a5,72(s1)
    8000264c:	68b8                	ld	a4,80(s1)
    8000264e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002650:	00234797          	auipc	a5,0x234
    80002654:	11078793          	addi	a5,a5,272 # 80236760 <bcache+0x8000>
    80002658:	2b87b703          	ld	a4,696(a5)
    8000265c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000265e:	00234717          	auipc	a4,0x234
    80002662:	36a70713          	addi	a4,a4,874 # 802369c8 <bcache+0x8268>
    80002666:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002668:	2b87b703          	ld	a4,696(a5)
    8000266c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000266e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002672:	0022c517          	auipc	a0,0x22c
    80002676:	0ee50513          	addi	a0,a0,238 # 8022e760 <bcache>
    8000267a:	00004097          	auipc	ra,0x4
    8000267e:	d0e080e7          	jalr	-754(ra) # 80006388 <release>
}
    80002682:	60e2                	ld	ra,24(sp)
    80002684:	6442                	ld	s0,16(sp)
    80002686:	64a2                	ld	s1,8(sp)
    80002688:	6902                	ld	s2,0(sp)
    8000268a:	6105                	addi	sp,sp,32
    8000268c:	8082                	ret
    panic("brelse");
    8000268e:	00006517          	auipc	a0,0x6
    80002692:	e2250513          	addi	a0,a0,-478 # 800084b0 <syscalls+0xe0>
    80002696:	00003097          	auipc	ra,0x3
    8000269a:	706080e7          	jalr	1798(ra) # 80005d9c <panic>

000000008000269e <bpin>:

void
bpin(struct buf *b) {
    8000269e:	1101                	addi	sp,sp,-32
    800026a0:	ec06                	sd	ra,24(sp)
    800026a2:	e822                	sd	s0,16(sp)
    800026a4:	e426                	sd	s1,8(sp)
    800026a6:	1000                	addi	s0,sp,32
    800026a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026aa:	0022c517          	auipc	a0,0x22c
    800026ae:	0b650513          	addi	a0,a0,182 # 8022e760 <bcache>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	c22080e7          	jalr	-990(ra) # 800062d4 <acquire>
  b->refcnt++;
    800026ba:	40bc                	lw	a5,64(s1)
    800026bc:	2785                	addiw	a5,a5,1
    800026be:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026c0:	0022c517          	auipc	a0,0x22c
    800026c4:	0a050513          	addi	a0,a0,160 # 8022e760 <bcache>
    800026c8:	00004097          	auipc	ra,0x4
    800026cc:	cc0080e7          	jalr	-832(ra) # 80006388 <release>
}
    800026d0:	60e2                	ld	ra,24(sp)
    800026d2:	6442                	ld	s0,16(sp)
    800026d4:	64a2                	ld	s1,8(sp)
    800026d6:	6105                	addi	sp,sp,32
    800026d8:	8082                	ret

00000000800026da <bunpin>:

void
bunpin(struct buf *b) {
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	1000                	addi	s0,sp,32
    800026e4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e6:	0022c517          	auipc	a0,0x22c
    800026ea:	07a50513          	addi	a0,a0,122 # 8022e760 <bcache>
    800026ee:	00004097          	auipc	ra,0x4
    800026f2:	be6080e7          	jalr	-1050(ra) # 800062d4 <acquire>
  b->refcnt--;
    800026f6:	40bc                	lw	a5,64(s1)
    800026f8:	37fd                	addiw	a5,a5,-1
    800026fa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026fc:	0022c517          	auipc	a0,0x22c
    80002700:	06450513          	addi	a0,a0,100 # 8022e760 <bcache>
    80002704:	00004097          	auipc	ra,0x4
    80002708:	c84080e7          	jalr	-892(ra) # 80006388 <release>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6105                	addi	sp,sp,32
    80002714:	8082                	ret

0000000080002716 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002716:	1101                	addi	sp,sp,-32
    80002718:	ec06                	sd	ra,24(sp)
    8000271a:	e822                	sd	s0,16(sp)
    8000271c:	e426                	sd	s1,8(sp)
    8000271e:	e04a                	sd	s2,0(sp)
    80002720:	1000                	addi	s0,sp,32
    80002722:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002724:	00d5d59b          	srliw	a1,a1,0xd
    80002728:	00234797          	auipc	a5,0x234
    8000272c:	7147a783          	lw	a5,1812(a5) # 80236e3c <sb+0x1c>
    80002730:	9dbd                	addw	a1,a1,a5
    80002732:	00000097          	auipc	ra,0x0
    80002736:	d9e080e7          	jalr	-610(ra) # 800024d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000273a:	0074f713          	andi	a4,s1,7
    8000273e:	4785                	li	a5,1
    80002740:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002744:	14ce                	slli	s1,s1,0x33
    80002746:	90d9                	srli	s1,s1,0x36
    80002748:	00950733          	add	a4,a0,s1
    8000274c:	05874703          	lbu	a4,88(a4)
    80002750:	00e7f6b3          	and	a3,a5,a4
    80002754:	c69d                	beqz	a3,80002782 <bfree+0x6c>
    80002756:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002758:	94aa                	add	s1,s1,a0
    8000275a:	fff7c793          	not	a5,a5
    8000275e:	8f7d                	and	a4,a4,a5
    80002760:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002764:	00001097          	auipc	ra,0x1
    80002768:	126080e7          	jalr	294(ra) # 8000388a <log_write>
  brelse(bp);
    8000276c:	854a                	mv	a0,s2
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	e92080e7          	jalr	-366(ra) # 80002600 <brelse>
}
    80002776:	60e2                	ld	ra,24(sp)
    80002778:	6442                	ld	s0,16(sp)
    8000277a:	64a2                	ld	s1,8(sp)
    8000277c:	6902                	ld	s2,0(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret
    panic("freeing free block");
    80002782:	00006517          	auipc	a0,0x6
    80002786:	d3650513          	addi	a0,a0,-714 # 800084b8 <syscalls+0xe8>
    8000278a:	00003097          	auipc	ra,0x3
    8000278e:	612080e7          	jalr	1554(ra) # 80005d9c <panic>

0000000080002792 <balloc>:
{
    80002792:	711d                	addi	sp,sp,-96
    80002794:	ec86                	sd	ra,88(sp)
    80002796:	e8a2                	sd	s0,80(sp)
    80002798:	e4a6                	sd	s1,72(sp)
    8000279a:	e0ca                	sd	s2,64(sp)
    8000279c:	fc4e                	sd	s3,56(sp)
    8000279e:	f852                	sd	s4,48(sp)
    800027a0:	f456                	sd	s5,40(sp)
    800027a2:	f05a                	sd	s6,32(sp)
    800027a4:	ec5e                	sd	s7,24(sp)
    800027a6:	e862                	sd	s8,16(sp)
    800027a8:	e466                	sd	s9,8(sp)
    800027aa:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027ac:	00234797          	auipc	a5,0x234
    800027b0:	6787a783          	lw	a5,1656(a5) # 80236e24 <sb+0x4>
    800027b4:	cff5                	beqz	a5,800028b0 <balloc+0x11e>
    800027b6:	8baa                	mv	s7,a0
    800027b8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027ba:	00234b17          	auipc	s6,0x234
    800027be:	666b0b13          	addi	s6,s6,1638 # 80236e20 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027c4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027c8:	6c89                	lui	s9,0x2
    800027ca:	a061                	j	80002852 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027cc:	97ca                	add	a5,a5,s2
    800027ce:	8e55                	or	a2,a2,a3
    800027d0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027d4:	854a                	mv	a0,s2
    800027d6:	00001097          	auipc	ra,0x1
    800027da:	0b4080e7          	jalr	180(ra) # 8000388a <log_write>
        brelse(bp);
    800027de:	854a                	mv	a0,s2
    800027e0:	00000097          	auipc	ra,0x0
    800027e4:	e20080e7          	jalr	-480(ra) # 80002600 <brelse>
  bp = bread(dev, bno);
    800027e8:	85a6                	mv	a1,s1
    800027ea:	855e                	mv	a0,s7
    800027ec:	00000097          	auipc	ra,0x0
    800027f0:	ce4080e7          	jalr	-796(ra) # 800024d0 <bread>
    800027f4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027f6:	40000613          	li	a2,1024
    800027fa:	4581                	li	a1,0
    800027fc:	05850513          	addi	a0,a0,88
    80002800:	ffffe097          	auipc	ra,0xffffe
    80002804:	9f8080e7          	jalr	-1544(ra) # 800001f8 <memset>
  log_write(bp);
    80002808:	854a                	mv	a0,s2
    8000280a:	00001097          	auipc	ra,0x1
    8000280e:	080080e7          	jalr	128(ra) # 8000388a <log_write>
  brelse(bp);
    80002812:	854a                	mv	a0,s2
    80002814:	00000097          	auipc	ra,0x0
    80002818:	dec080e7          	jalr	-532(ra) # 80002600 <brelse>
}
    8000281c:	8526                	mv	a0,s1
    8000281e:	60e6                	ld	ra,88(sp)
    80002820:	6446                	ld	s0,80(sp)
    80002822:	64a6                	ld	s1,72(sp)
    80002824:	6906                	ld	s2,64(sp)
    80002826:	79e2                	ld	s3,56(sp)
    80002828:	7a42                	ld	s4,48(sp)
    8000282a:	7aa2                	ld	s5,40(sp)
    8000282c:	7b02                	ld	s6,32(sp)
    8000282e:	6be2                	ld	s7,24(sp)
    80002830:	6c42                	ld	s8,16(sp)
    80002832:	6ca2                	ld	s9,8(sp)
    80002834:	6125                	addi	sp,sp,96
    80002836:	8082                	ret
    brelse(bp);
    80002838:	854a                	mv	a0,s2
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	dc6080e7          	jalr	-570(ra) # 80002600 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002842:	015c87bb          	addw	a5,s9,s5
    80002846:	00078a9b          	sext.w	s5,a5
    8000284a:	004b2703          	lw	a4,4(s6)
    8000284e:	06eaf163          	bgeu	s5,a4,800028b0 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002852:	41fad79b          	sraiw	a5,s5,0x1f
    80002856:	0137d79b          	srliw	a5,a5,0x13
    8000285a:	015787bb          	addw	a5,a5,s5
    8000285e:	40d7d79b          	sraiw	a5,a5,0xd
    80002862:	01cb2583          	lw	a1,28(s6)
    80002866:	9dbd                	addw	a1,a1,a5
    80002868:	855e                	mv	a0,s7
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	c66080e7          	jalr	-922(ra) # 800024d0 <bread>
    80002872:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002874:	004b2503          	lw	a0,4(s6)
    80002878:	000a849b          	sext.w	s1,s5
    8000287c:	8762                	mv	a4,s8
    8000287e:	faa4fde3          	bgeu	s1,a0,80002838 <balloc+0xa6>
      m = 1 << (bi % 8);
    80002882:	00777693          	andi	a3,a4,7
    80002886:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000288a:	41f7579b          	sraiw	a5,a4,0x1f
    8000288e:	01d7d79b          	srliw	a5,a5,0x1d
    80002892:	9fb9                	addw	a5,a5,a4
    80002894:	4037d79b          	sraiw	a5,a5,0x3
    80002898:	00f90633          	add	a2,s2,a5
    8000289c:	05864603          	lbu	a2,88(a2)
    800028a0:	00c6f5b3          	and	a1,a3,a2
    800028a4:	d585                	beqz	a1,800027cc <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028a6:	2705                	addiw	a4,a4,1
    800028a8:	2485                	addiw	s1,s1,1
    800028aa:	fd471ae3          	bne	a4,s4,8000287e <balloc+0xec>
    800028ae:	b769                	j	80002838 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800028b0:	00006517          	auipc	a0,0x6
    800028b4:	c2050513          	addi	a0,a0,-992 # 800084d0 <syscalls+0x100>
    800028b8:	00003097          	auipc	ra,0x3
    800028bc:	52e080e7          	jalr	1326(ra) # 80005de6 <printf>
  return 0;
    800028c0:	4481                	li	s1,0
    800028c2:	bfa9                	j	8000281c <balloc+0x8a>

00000000800028c4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800028c4:	7179                	addi	sp,sp,-48
    800028c6:	f406                	sd	ra,40(sp)
    800028c8:	f022                	sd	s0,32(sp)
    800028ca:	ec26                	sd	s1,24(sp)
    800028cc:	e84a                	sd	s2,16(sp)
    800028ce:	e44e                	sd	s3,8(sp)
    800028d0:	e052                	sd	s4,0(sp)
    800028d2:	1800                	addi	s0,sp,48
    800028d4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028d6:	47ad                	li	a5,11
    800028d8:	02b7e863          	bltu	a5,a1,80002908 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800028dc:	02059793          	slli	a5,a1,0x20
    800028e0:	01e7d593          	srli	a1,a5,0x1e
    800028e4:	00b504b3          	add	s1,a0,a1
    800028e8:	0504a903          	lw	s2,80(s1)
    800028ec:	06091e63          	bnez	s2,80002968 <bmap+0xa4>
      addr = balloc(ip->dev);
    800028f0:	4108                	lw	a0,0(a0)
    800028f2:	00000097          	auipc	ra,0x0
    800028f6:	ea0080e7          	jalr	-352(ra) # 80002792 <balloc>
    800028fa:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028fe:	06090563          	beqz	s2,80002968 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002902:	0524a823          	sw	s2,80(s1)
    80002906:	a08d                	j	80002968 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002908:	ff45849b          	addiw	s1,a1,-12
    8000290c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002910:	0ff00793          	li	a5,255
    80002914:	08e7e563          	bltu	a5,a4,8000299e <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002918:	08052903          	lw	s2,128(a0)
    8000291c:	00091d63          	bnez	s2,80002936 <bmap+0x72>
      addr = balloc(ip->dev);
    80002920:	4108                	lw	a0,0(a0)
    80002922:	00000097          	auipc	ra,0x0
    80002926:	e70080e7          	jalr	-400(ra) # 80002792 <balloc>
    8000292a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000292e:	02090d63          	beqz	s2,80002968 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002932:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002936:	85ca                	mv	a1,s2
    80002938:	0009a503          	lw	a0,0(s3)
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	b94080e7          	jalr	-1132(ra) # 800024d0 <bread>
    80002944:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002946:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000294a:	02049713          	slli	a4,s1,0x20
    8000294e:	01e75593          	srli	a1,a4,0x1e
    80002952:	00b784b3          	add	s1,a5,a1
    80002956:	0004a903          	lw	s2,0(s1)
    8000295a:	02090063          	beqz	s2,8000297a <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000295e:	8552                	mv	a0,s4
    80002960:	00000097          	auipc	ra,0x0
    80002964:	ca0080e7          	jalr	-864(ra) # 80002600 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002968:	854a                	mv	a0,s2
    8000296a:	70a2                	ld	ra,40(sp)
    8000296c:	7402                	ld	s0,32(sp)
    8000296e:	64e2                	ld	s1,24(sp)
    80002970:	6942                	ld	s2,16(sp)
    80002972:	69a2                	ld	s3,8(sp)
    80002974:	6a02                	ld	s4,0(sp)
    80002976:	6145                	addi	sp,sp,48
    80002978:	8082                	ret
      addr = balloc(ip->dev);
    8000297a:	0009a503          	lw	a0,0(s3)
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	e14080e7          	jalr	-492(ra) # 80002792 <balloc>
    80002986:	0005091b          	sext.w	s2,a0
      if(addr){
    8000298a:	fc090ae3          	beqz	s2,8000295e <bmap+0x9a>
        a[bn] = addr;
    8000298e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002992:	8552                	mv	a0,s4
    80002994:	00001097          	auipc	ra,0x1
    80002998:	ef6080e7          	jalr	-266(ra) # 8000388a <log_write>
    8000299c:	b7c9                	j	8000295e <bmap+0x9a>
  panic("bmap: out of range");
    8000299e:	00006517          	auipc	a0,0x6
    800029a2:	b4a50513          	addi	a0,a0,-1206 # 800084e8 <syscalls+0x118>
    800029a6:	00003097          	auipc	ra,0x3
    800029aa:	3f6080e7          	jalr	1014(ra) # 80005d9c <panic>

00000000800029ae <iget>:
{
    800029ae:	7179                	addi	sp,sp,-48
    800029b0:	f406                	sd	ra,40(sp)
    800029b2:	f022                	sd	s0,32(sp)
    800029b4:	ec26                	sd	s1,24(sp)
    800029b6:	e84a                	sd	s2,16(sp)
    800029b8:	e44e                	sd	s3,8(sp)
    800029ba:	e052                	sd	s4,0(sp)
    800029bc:	1800                	addi	s0,sp,48
    800029be:	89aa                	mv	s3,a0
    800029c0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029c2:	00234517          	auipc	a0,0x234
    800029c6:	47e50513          	addi	a0,a0,1150 # 80236e40 <itable>
    800029ca:	00004097          	auipc	ra,0x4
    800029ce:	90a080e7          	jalr	-1782(ra) # 800062d4 <acquire>
  empty = 0;
    800029d2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029d4:	00234497          	auipc	s1,0x234
    800029d8:	48448493          	addi	s1,s1,1156 # 80236e58 <itable+0x18>
    800029dc:	00236697          	auipc	a3,0x236
    800029e0:	f0c68693          	addi	a3,a3,-244 # 802388e8 <log>
    800029e4:	a039                	j	800029f2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029e6:	02090b63          	beqz	s2,80002a1c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029ea:	08848493          	addi	s1,s1,136
    800029ee:	02d48a63          	beq	s1,a3,80002a22 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029f2:	449c                	lw	a5,8(s1)
    800029f4:	fef059e3          	blez	a5,800029e6 <iget+0x38>
    800029f8:	4098                	lw	a4,0(s1)
    800029fa:	ff3716e3          	bne	a4,s3,800029e6 <iget+0x38>
    800029fe:	40d8                	lw	a4,4(s1)
    80002a00:	ff4713e3          	bne	a4,s4,800029e6 <iget+0x38>
      ip->ref++;
    80002a04:	2785                	addiw	a5,a5,1
    80002a06:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a08:	00234517          	auipc	a0,0x234
    80002a0c:	43850513          	addi	a0,a0,1080 # 80236e40 <itable>
    80002a10:	00004097          	auipc	ra,0x4
    80002a14:	978080e7          	jalr	-1672(ra) # 80006388 <release>
      return ip;
    80002a18:	8926                	mv	s2,s1
    80002a1a:	a03d                	j	80002a48 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a1c:	f7f9                	bnez	a5,800029ea <iget+0x3c>
    80002a1e:	8926                	mv	s2,s1
    80002a20:	b7e9                	j	800029ea <iget+0x3c>
  if(empty == 0)
    80002a22:	02090c63          	beqz	s2,80002a5a <iget+0xac>
  ip->dev = dev;
    80002a26:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a2a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a2e:	4785                	li	a5,1
    80002a30:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a34:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a38:	00234517          	auipc	a0,0x234
    80002a3c:	40850513          	addi	a0,a0,1032 # 80236e40 <itable>
    80002a40:	00004097          	auipc	ra,0x4
    80002a44:	948080e7          	jalr	-1720(ra) # 80006388 <release>
}
    80002a48:	854a                	mv	a0,s2
    80002a4a:	70a2                	ld	ra,40(sp)
    80002a4c:	7402                	ld	s0,32(sp)
    80002a4e:	64e2                	ld	s1,24(sp)
    80002a50:	6942                	ld	s2,16(sp)
    80002a52:	69a2                	ld	s3,8(sp)
    80002a54:	6a02                	ld	s4,0(sp)
    80002a56:	6145                	addi	sp,sp,48
    80002a58:	8082                	ret
    panic("iget: no inodes");
    80002a5a:	00006517          	auipc	a0,0x6
    80002a5e:	aa650513          	addi	a0,a0,-1370 # 80008500 <syscalls+0x130>
    80002a62:	00003097          	auipc	ra,0x3
    80002a66:	33a080e7          	jalr	826(ra) # 80005d9c <panic>

0000000080002a6a <fsinit>:
fsinit(int dev) {
    80002a6a:	7179                	addi	sp,sp,-48
    80002a6c:	f406                	sd	ra,40(sp)
    80002a6e:	f022                	sd	s0,32(sp)
    80002a70:	ec26                	sd	s1,24(sp)
    80002a72:	e84a                	sd	s2,16(sp)
    80002a74:	e44e                	sd	s3,8(sp)
    80002a76:	1800                	addi	s0,sp,48
    80002a78:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a7a:	4585                	li	a1,1
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	a54080e7          	jalr	-1452(ra) # 800024d0 <bread>
    80002a84:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a86:	00234997          	auipc	s3,0x234
    80002a8a:	39a98993          	addi	s3,s3,922 # 80236e20 <sb>
    80002a8e:	02000613          	li	a2,32
    80002a92:	05850593          	addi	a1,a0,88
    80002a96:	854e                	mv	a0,s3
    80002a98:	ffffd097          	auipc	ra,0xffffd
    80002a9c:	7bc080e7          	jalr	1980(ra) # 80000254 <memmove>
  brelse(bp);
    80002aa0:	8526                	mv	a0,s1
    80002aa2:	00000097          	auipc	ra,0x0
    80002aa6:	b5e080e7          	jalr	-1186(ra) # 80002600 <brelse>
  if(sb.magic != FSMAGIC)
    80002aaa:	0009a703          	lw	a4,0(s3)
    80002aae:	102037b7          	lui	a5,0x10203
    80002ab2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ab6:	02f71263          	bne	a4,a5,80002ada <fsinit+0x70>
  initlog(dev, &sb);
    80002aba:	00234597          	auipc	a1,0x234
    80002abe:	36658593          	addi	a1,a1,870 # 80236e20 <sb>
    80002ac2:	854a                	mv	a0,s2
    80002ac4:	00001097          	auipc	ra,0x1
    80002ac8:	b4a080e7          	jalr	-1206(ra) # 8000360e <initlog>
}
    80002acc:	70a2                	ld	ra,40(sp)
    80002ace:	7402                	ld	s0,32(sp)
    80002ad0:	64e2                	ld	s1,24(sp)
    80002ad2:	6942                	ld	s2,16(sp)
    80002ad4:	69a2                	ld	s3,8(sp)
    80002ad6:	6145                	addi	sp,sp,48
    80002ad8:	8082                	ret
    panic("invalid file system");
    80002ada:	00006517          	auipc	a0,0x6
    80002ade:	a3650513          	addi	a0,a0,-1482 # 80008510 <syscalls+0x140>
    80002ae2:	00003097          	auipc	ra,0x3
    80002ae6:	2ba080e7          	jalr	698(ra) # 80005d9c <panic>

0000000080002aea <iinit>:
{
    80002aea:	7179                	addi	sp,sp,-48
    80002aec:	f406                	sd	ra,40(sp)
    80002aee:	f022                	sd	s0,32(sp)
    80002af0:	ec26                	sd	s1,24(sp)
    80002af2:	e84a                	sd	s2,16(sp)
    80002af4:	e44e                	sd	s3,8(sp)
    80002af6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002af8:	00006597          	auipc	a1,0x6
    80002afc:	a3058593          	addi	a1,a1,-1488 # 80008528 <syscalls+0x158>
    80002b00:	00234517          	auipc	a0,0x234
    80002b04:	34050513          	addi	a0,a0,832 # 80236e40 <itable>
    80002b08:	00003097          	auipc	ra,0x3
    80002b0c:	73c080e7          	jalr	1852(ra) # 80006244 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b10:	00234497          	auipc	s1,0x234
    80002b14:	35848493          	addi	s1,s1,856 # 80236e68 <itable+0x28>
    80002b18:	00236997          	auipc	s3,0x236
    80002b1c:	de098993          	addi	s3,s3,-544 # 802388f8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b20:	00006917          	auipc	s2,0x6
    80002b24:	a1090913          	addi	s2,s2,-1520 # 80008530 <syscalls+0x160>
    80002b28:	85ca                	mv	a1,s2
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	00001097          	auipc	ra,0x1
    80002b30:	e42080e7          	jalr	-446(ra) # 8000396e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b34:	08848493          	addi	s1,s1,136
    80002b38:	ff3498e3          	bne	s1,s3,80002b28 <iinit+0x3e>
}
    80002b3c:	70a2                	ld	ra,40(sp)
    80002b3e:	7402                	ld	s0,32(sp)
    80002b40:	64e2                	ld	s1,24(sp)
    80002b42:	6942                	ld	s2,16(sp)
    80002b44:	69a2                	ld	s3,8(sp)
    80002b46:	6145                	addi	sp,sp,48
    80002b48:	8082                	ret

0000000080002b4a <ialloc>:
{
    80002b4a:	715d                	addi	sp,sp,-80
    80002b4c:	e486                	sd	ra,72(sp)
    80002b4e:	e0a2                	sd	s0,64(sp)
    80002b50:	fc26                	sd	s1,56(sp)
    80002b52:	f84a                	sd	s2,48(sp)
    80002b54:	f44e                	sd	s3,40(sp)
    80002b56:	f052                	sd	s4,32(sp)
    80002b58:	ec56                	sd	s5,24(sp)
    80002b5a:	e85a                	sd	s6,16(sp)
    80002b5c:	e45e                	sd	s7,8(sp)
    80002b5e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b60:	00234717          	auipc	a4,0x234
    80002b64:	2cc72703          	lw	a4,716(a4) # 80236e2c <sb+0xc>
    80002b68:	4785                	li	a5,1
    80002b6a:	04e7fa63          	bgeu	a5,a4,80002bbe <ialloc+0x74>
    80002b6e:	8aaa                	mv	s5,a0
    80002b70:	8bae                	mv	s7,a1
    80002b72:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b74:	00234a17          	auipc	s4,0x234
    80002b78:	2aca0a13          	addi	s4,s4,684 # 80236e20 <sb>
    80002b7c:	00048b1b          	sext.w	s6,s1
    80002b80:	0044d593          	srli	a1,s1,0x4
    80002b84:	018a2783          	lw	a5,24(s4)
    80002b88:	9dbd                	addw	a1,a1,a5
    80002b8a:	8556                	mv	a0,s5
    80002b8c:	00000097          	auipc	ra,0x0
    80002b90:	944080e7          	jalr	-1724(ra) # 800024d0 <bread>
    80002b94:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b96:	05850993          	addi	s3,a0,88
    80002b9a:	00f4f793          	andi	a5,s1,15
    80002b9e:	079a                	slli	a5,a5,0x6
    80002ba0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ba2:	00099783          	lh	a5,0(s3)
    80002ba6:	c3a1                	beqz	a5,80002be6 <ialloc+0x9c>
    brelse(bp);
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	a58080e7          	jalr	-1448(ra) # 80002600 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bb0:	0485                	addi	s1,s1,1
    80002bb2:	00ca2703          	lw	a4,12(s4)
    80002bb6:	0004879b          	sext.w	a5,s1
    80002bba:	fce7e1e3          	bltu	a5,a4,80002b7c <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002bbe:	00006517          	auipc	a0,0x6
    80002bc2:	97a50513          	addi	a0,a0,-1670 # 80008538 <syscalls+0x168>
    80002bc6:	00003097          	auipc	ra,0x3
    80002bca:	220080e7          	jalr	544(ra) # 80005de6 <printf>
  return 0;
    80002bce:	4501                	li	a0,0
}
    80002bd0:	60a6                	ld	ra,72(sp)
    80002bd2:	6406                	ld	s0,64(sp)
    80002bd4:	74e2                	ld	s1,56(sp)
    80002bd6:	7942                	ld	s2,48(sp)
    80002bd8:	79a2                	ld	s3,40(sp)
    80002bda:	7a02                	ld	s4,32(sp)
    80002bdc:	6ae2                	ld	s5,24(sp)
    80002bde:	6b42                	ld	s6,16(sp)
    80002be0:	6ba2                	ld	s7,8(sp)
    80002be2:	6161                	addi	sp,sp,80
    80002be4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002be6:	04000613          	li	a2,64
    80002bea:	4581                	li	a1,0
    80002bec:	854e                	mv	a0,s3
    80002bee:	ffffd097          	auipc	ra,0xffffd
    80002bf2:	60a080e7          	jalr	1546(ra) # 800001f8 <memset>
      dip->type = type;
    80002bf6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bfa:	854a                	mv	a0,s2
    80002bfc:	00001097          	auipc	ra,0x1
    80002c00:	c8e080e7          	jalr	-882(ra) # 8000388a <log_write>
      brelse(bp);
    80002c04:	854a                	mv	a0,s2
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	9fa080e7          	jalr	-1542(ra) # 80002600 <brelse>
      return iget(dev, inum);
    80002c0e:	85da                	mv	a1,s6
    80002c10:	8556                	mv	a0,s5
    80002c12:	00000097          	auipc	ra,0x0
    80002c16:	d9c080e7          	jalr	-612(ra) # 800029ae <iget>
    80002c1a:	bf5d                	j	80002bd0 <ialloc+0x86>

0000000080002c1c <iupdate>:
{
    80002c1c:	1101                	addi	sp,sp,-32
    80002c1e:	ec06                	sd	ra,24(sp)
    80002c20:	e822                	sd	s0,16(sp)
    80002c22:	e426                	sd	s1,8(sp)
    80002c24:	e04a                	sd	s2,0(sp)
    80002c26:	1000                	addi	s0,sp,32
    80002c28:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c2a:	415c                	lw	a5,4(a0)
    80002c2c:	0047d79b          	srliw	a5,a5,0x4
    80002c30:	00234597          	auipc	a1,0x234
    80002c34:	2085a583          	lw	a1,520(a1) # 80236e38 <sb+0x18>
    80002c38:	9dbd                	addw	a1,a1,a5
    80002c3a:	4108                	lw	a0,0(a0)
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	894080e7          	jalr	-1900(ra) # 800024d0 <bread>
    80002c44:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c46:	05850793          	addi	a5,a0,88
    80002c4a:	40d8                	lw	a4,4(s1)
    80002c4c:	8b3d                	andi	a4,a4,15
    80002c4e:	071a                	slli	a4,a4,0x6
    80002c50:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c52:	04449703          	lh	a4,68(s1)
    80002c56:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c5a:	04649703          	lh	a4,70(s1)
    80002c5e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c62:	04849703          	lh	a4,72(s1)
    80002c66:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c6a:	04a49703          	lh	a4,74(s1)
    80002c6e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c72:	44f8                	lw	a4,76(s1)
    80002c74:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c76:	03400613          	li	a2,52
    80002c7a:	05048593          	addi	a1,s1,80
    80002c7e:	00c78513          	addi	a0,a5,12
    80002c82:	ffffd097          	auipc	ra,0xffffd
    80002c86:	5d2080e7          	jalr	1490(ra) # 80000254 <memmove>
  log_write(bp);
    80002c8a:	854a                	mv	a0,s2
    80002c8c:	00001097          	auipc	ra,0x1
    80002c90:	bfe080e7          	jalr	-1026(ra) # 8000388a <log_write>
  brelse(bp);
    80002c94:	854a                	mv	a0,s2
    80002c96:	00000097          	auipc	ra,0x0
    80002c9a:	96a080e7          	jalr	-1686(ra) # 80002600 <brelse>
}
    80002c9e:	60e2                	ld	ra,24(sp)
    80002ca0:	6442                	ld	s0,16(sp)
    80002ca2:	64a2                	ld	s1,8(sp)
    80002ca4:	6902                	ld	s2,0(sp)
    80002ca6:	6105                	addi	sp,sp,32
    80002ca8:	8082                	ret

0000000080002caa <idup>:
{
    80002caa:	1101                	addi	sp,sp,-32
    80002cac:	ec06                	sd	ra,24(sp)
    80002cae:	e822                	sd	s0,16(sp)
    80002cb0:	e426                	sd	s1,8(sp)
    80002cb2:	1000                	addi	s0,sp,32
    80002cb4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cb6:	00234517          	auipc	a0,0x234
    80002cba:	18a50513          	addi	a0,a0,394 # 80236e40 <itable>
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	616080e7          	jalr	1558(ra) # 800062d4 <acquire>
  ip->ref++;
    80002cc6:	449c                	lw	a5,8(s1)
    80002cc8:	2785                	addiw	a5,a5,1
    80002cca:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ccc:	00234517          	auipc	a0,0x234
    80002cd0:	17450513          	addi	a0,a0,372 # 80236e40 <itable>
    80002cd4:	00003097          	auipc	ra,0x3
    80002cd8:	6b4080e7          	jalr	1716(ra) # 80006388 <release>
}
    80002cdc:	8526                	mv	a0,s1
    80002cde:	60e2                	ld	ra,24(sp)
    80002ce0:	6442                	ld	s0,16(sp)
    80002ce2:	64a2                	ld	s1,8(sp)
    80002ce4:	6105                	addi	sp,sp,32
    80002ce6:	8082                	ret

0000000080002ce8 <ilock>:
{
    80002ce8:	1101                	addi	sp,sp,-32
    80002cea:	ec06                	sd	ra,24(sp)
    80002cec:	e822                	sd	s0,16(sp)
    80002cee:	e426                	sd	s1,8(sp)
    80002cf0:	e04a                	sd	s2,0(sp)
    80002cf2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cf4:	c115                	beqz	a0,80002d18 <ilock+0x30>
    80002cf6:	84aa                	mv	s1,a0
    80002cf8:	451c                	lw	a5,8(a0)
    80002cfa:	00f05f63          	blez	a5,80002d18 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cfe:	0541                	addi	a0,a0,16
    80002d00:	00001097          	auipc	ra,0x1
    80002d04:	ca8080e7          	jalr	-856(ra) # 800039a8 <acquiresleep>
  if(ip->valid == 0){
    80002d08:	40bc                	lw	a5,64(s1)
    80002d0a:	cf99                	beqz	a5,80002d28 <ilock+0x40>
}
    80002d0c:	60e2                	ld	ra,24(sp)
    80002d0e:	6442                	ld	s0,16(sp)
    80002d10:	64a2                	ld	s1,8(sp)
    80002d12:	6902                	ld	s2,0(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret
    panic("ilock");
    80002d18:	00006517          	auipc	a0,0x6
    80002d1c:	83850513          	addi	a0,a0,-1992 # 80008550 <syscalls+0x180>
    80002d20:	00003097          	auipc	ra,0x3
    80002d24:	07c080e7          	jalr	124(ra) # 80005d9c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d28:	40dc                	lw	a5,4(s1)
    80002d2a:	0047d79b          	srliw	a5,a5,0x4
    80002d2e:	00234597          	auipc	a1,0x234
    80002d32:	10a5a583          	lw	a1,266(a1) # 80236e38 <sb+0x18>
    80002d36:	9dbd                	addw	a1,a1,a5
    80002d38:	4088                	lw	a0,0(s1)
    80002d3a:	fffff097          	auipc	ra,0xfffff
    80002d3e:	796080e7          	jalr	1942(ra) # 800024d0 <bread>
    80002d42:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d44:	05850593          	addi	a1,a0,88
    80002d48:	40dc                	lw	a5,4(s1)
    80002d4a:	8bbd                	andi	a5,a5,15
    80002d4c:	079a                	slli	a5,a5,0x6
    80002d4e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d50:	00059783          	lh	a5,0(a1)
    80002d54:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d58:	00259783          	lh	a5,2(a1)
    80002d5c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d60:	00459783          	lh	a5,4(a1)
    80002d64:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d68:	00659783          	lh	a5,6(a1)
    80002d6c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d70:	459c                	lw	a5,8(a1)
    80002d72:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d74:	03400613          	li	a2,52
    80002d78:	05b1                	addi	a1,a1,12
    80002d7a:	05048513          	addi	a0,s1,80
    80002d7e:	ffffd097          	auipc	ra,0xffffd
    80002d82:	4d6080e7          	jalr	1238(ra) # 80000254 <memmove>
    brelse(bp);
    80002d86:	854a                	mv	a0,s2
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	878080e7          	jalr	-1928(ra) # 80002600 <brelse>
    ip->valid = 1;
    80002d90:	4785                	li	a5,1
    80002d92:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d94:	04449783          	lh	a5,68(s1)
    80002d98:	fbb5                	bnez	a5,80002d0c <ilock+0x24>
      panic("ilock: no type");
    80002d9a:	00005517          	auipc	a0,0x5
    80002d9e:	7be50513          	addi	a0,a0,1982 # 80008558 <syscalls+0x188>
    80002da2:	00003097          	auipc	ra,0x3
    80002da6:	ffa080e7          	jalr	-6(ra) # 80005d9c <panic>

0000000080002daa <iunlock>:
{
    80002daa:	1101                	addi	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	e426                	sd	s1,8(sp)
    80002db2:	e04a                	sd	s2,0(sp)
    80002db4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002db6:	c905                	beqz	a0,80002de6 <iunlock+0x3c>
    80002db8:	84aa                	mv	s1,a0
    80002dba:	01050913          	addi	s2,a0,16
    80002dbe:	854a                	mv	a0,s2
    80002dc0:	00001097          	auipc	ra,0x1
    80002dc4:	c82080e7          	jalr	-894(ra) # 80003a42 <holdingsleep>
    80002dc8:	cd19                	beqz	a0,80002de6 <iunlock+0x3c>
    80002dca:	449c                	lw	a5,8(s1)
    80002dcc:	00f05d63          	blez	a5,80002de6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dd0:	854a                	mv	a0,s2
    80002dd2:	00001097          	auipc	ra,0x1
    80002dd6:	c2c080e7          	jalr	-980(ra) # 800039fe <releasesleep>
}
    80002dda:	60e2                	ld	ra,24(sp)
    80002ddc:	6442                	ld	s0,16(sp)
    80002dde:	64a2                	ld	s1,8(sp)
    80002de0:	6902                	ld	s2,0(sp)
    80002de2:	6105                	addi	sp,sp,32
    80002de4:	8082                	ret
    panic("iunlock");
    80002de6:	00005517          	auipc	a0,0x5
    80002dea:	78250513          	addi	a0,a0,1922 # 80008568 <syscalls+0x198>
    80002dee:	00003097          	auipc	ra,0x3
    80002df2:	fae080e7          	jalr	-82(ra) # 80005d9c <panic>

0000000080002df6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002df6:	7179                	addi	sp,sp,-48
    80002df8:	f406                	sd	ra,40(sp)
    80002dfa:	f022                	sd	s0,32(sp)
    80002dfc:	ec26                	sd	s1,24(sp)
    80002dfe:	e84a                	sd	s2,16(sp)
    80002e00:	e44e                	sd	s3,8(sp)
    80002e02:	e052                	sd	s4,0(sp)
    80002e04:	1800                	addi	s0,sp,48
    80002e06:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e08:	05050493          	addi	s1,a0,80
    80002e0c:	08050913          	addi	s2,a0,128
    80002e10:	a021                	j	80002e18 <itrunc+0x22>
    80002e12:	0491                	addi	s1,s1,4
    80002e14:	01248d63          	beq	s1,s2,80002e2e <itrunc+0x38>
    if(ip->addrs[i]){
    80002e18:	408c                	lw	a1,0(s1)
    80002e1a:	dde5                	beqz	a1,80002e12 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e1c:	0009a503          	lw	a0,0(s3)
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	8f6080e7          	jalr	-1802(ra) # 80002716 <bfree>
      ip->addrs[i] = 0;
    80002e28:	0004a023          	sw	zero,0(s1)
    80002e2c:	b7dd                	j	80002e12 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e2e:	0809a583          	lw	a1,128(s3)
    80002e32:	e185                	bnez	a1,80002e52 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e34:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e38:	854e                	mv	a0,s3
    80002e3a:	00000097          	auipc	ra,0x0
    80002e3e:	de2080e7          	jalr	-542(ra) # 80002c1c <iupdate>
}
    80002e42:	70a2                	ld	ra,40(sp)
    80002e44:	7402                	ld	s0,32(sp)
    80002e46:	64e2                	ld	s1,24(sp)
    80002e48:	6942                	ld	s2,16(sp)
    80002e4a:	69a2                	ld	s3,8(sp)
    80002e4c:	6a02                	ld	s4,0(sp)
    80002e4e:	6145                	addi	sp,sp,48
    80002e50:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e52:	0009a503          	lw	a0,0(s3)
    80002e56:	fffff097          	auipc	ra,0xfffff
    80002e5a:	67a080e7          	jalr	1658(ra) # 800024d0 <bread>
    80002e5e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e60:	05850493          	addi	s1,a0,88
    80002e64:	45850913          	addi	s2,a0,1112
    80002e68:	a021                	j	80002e70 <itrunc+0x7a>
    80002e6a:	0491                	addi	s1,s1,4
    80002e6c:	01248b63          	beq	s1,s2,80002e82 <itrunc+0x8c>
      if(a[j])
    80002e70:	408c                	lw	a1,0(s1)
    80002e72:	dde5                	beqz	a1,80002e6a <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e74:	0009a503          	lw	a0,0(s3)
    80002e78:	00000097          	auipc	ra,0x0
    80002e7c:	89e080e7          	jalr	-1890(ra) # 80002716 <bfree>
    80002e80:	b7ed                	j	80002e6a <itrunc+0x74>
    brelse(bp);
    80002e82:	8552                	mv	a0,s4
    80002e84:	fffff097          	auipc	ra,0xfffff
    80002e88:	77c080e7          	jalr	1916(ra) # 80002600 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e8c:	0809a583          	lw	a1,128(s3)
    80002e90:	0009a503          	lw	a0,0(s3)
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	882080e7          	jalr	-1918(ra) # 80002716 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e9c:	0809a023          	sw	zero,128(s3)
    80002ea0:	bf51                	j	80002e34 <itrunc+0x3e>

0000000080002ea2 <iput>:
{
    80002ea2:	1101                	addi	sp,sp,-32
    80002ea4:	ec06                	sd	ra,24(sp)
    80002ea6:	e822                	sd	s0,16(sp)
    80002ea8:	e426                	sd	s1,8(sp)
    80002eaa:	e04a                	sd	s2,0(sp)
    80002eac:	1000                	addi	s0,sp,32
    80002eae:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002eb0:	00234517          	auipc	a0,0x234
    80002eb4:	f9050513          	addi	a0,a0,-112 # 80236e40 <itable>
    80002eb8:	00003097          	auipc	ra,0x3
    80002ebc:	41c080e7          	jalr	1052(ra) # 800062d4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ec0:	4498                	lw	a4,8(s1)
    80002ec2:	4785                	li	a5,1
    80002ec4:	02f70363          	beq	a4,a5,80002eea <iput+0x48>
  ip->ref--;
    80002ec8:	449c                	lw	a5,8(s1)
    80002eca:	37fd                	addiw	a5,a5,-1
    80002ecc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ece:	00234517          	auipc	a0,0x234
    80002ed2:	f7250513          	addi	a0,a0,-142 # 80236e40 <itable>
    80002ed6:	00003097          	auipc	ra,0x3
    80002eda:	4b2080e7          	jalr	1202(ra) # 80006388 <release>
}
    80002ede:	60e2                	ld	ra,24(sp)
    80002ee0:	6442                	ld	s0,16(sp)
    80002ee2:	64a2                	ld	s1,8(sp)
    80002ee4:	6902                	ld	s2,0(sp)
    80002ee6:	6105                	addi	sp,sp,32
    80002ee8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eea:	40bc                	lw	a5,64(s1)
    80002eec:	dff1                	beqz	a5,80002ec8 <iput+0x26>
    80002eee:	04a49783          	lh	a5,74(s1)
    80002ef2:	fbf9                	bnez	a5,80002ec8 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ef4:	01048913          	addi	s2,s1,16
    80002ef8:	854a                	mv	a0,s2
    80002efa:	00001097          	auipc	ra,0x1
    80002efe:	aae080e7          	jalr	-1362(ra) # 800039a8 <acquiresleep>
    release(&itable.lock);
    80002f02:	00234517          	auipc	a0,0x234
    80002f06:	f3e50513          	addi	a0,a0,-194 # 80236e40 <itable>
    80002f0a:	00003097          	auipc	ra,0x3
    80002f0e:	47e080e7          	jalr	1150(ra) # 80006388 <release>
    itrunc(ip);
    80002f12:	8526                	mv	a0,s1
    80002f14:	00000097          	auipc	ra,0x0
    80002f18:	ee2080e7          	jalr	-286(ra) # 80002df6 <itrunc>
    ip->type = 0;
    80002f1c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f20:	8526                	mv	a0,s1
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	cfa080e7          	jalr	-774(ra) # 80002c1c <iupdate>
    ip->valid = 0;
    80002f2a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f2e:	854a                	mv	a0,s2
    80002f30:	00001097          	auipc	ra,0x1
    80002f34:	ace080e7          	jalr	-1330(ra) # 800039fe <releasesleep>
    acquire(&itable.lock);
    80002f38:	00234517          	auipc	a0,0x234
    80002f3c:	f0850513          	addi	a0,a0,-248 # 80236e40 <itable>
    80002f40:	00003097          	auipc	ra,0x3
    80002f44:	394080e7          	jalr	916(ra) # 800062d4 <acquire>
    80002f48:	b741                	j	80002ec8 <iput+0x26>

0000000080002f4a <iunlockput>:
{
    80002f4a:	1101                	addi	sp,sp,-32
    80002f4c:	ec06                	sd	ra,24(sp)
    80002f4e:	e822                	sd	s0,16(sp)
    80002f50:	e426                	sd	s1,8(sp)
    80002f52:	1000                	addi	s0,sp,32
    80002f54:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f56:	00000097          	auipc	ra,0x0
    80002f5a:	e54080e7          	jalr	-428(ra) # 80002daa <iunlock>
  iput(ip);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	00000097          	auipc	ra,0x0
    80002f64:	f42080e7          	jalr	-190(ra) # 80002ea2 <iput>
}
    80002f68:	60e2                	ld	ra,24(sp)
    80002f6a:	6442                	ld	s0,16(sp)
    80002f6c:	64a2                	ld	s1,8(sp)
    80002f6e:	6105                	addi	sp,sp,32
    80002f70:	8082                	ret

0000000080002f72 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f72:	1141                	addi	sp,sp,-16
    80002f74:	e422                	sd	s0,8(sp)
    80002f76:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f78:	411c                	lw	a5,0(a0)
    80002f7a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f7c:	415c                	lw	a5,4(a0)
    80002f7e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f80:	04451783          	lh	a5,68(a0)
    80002f84:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f88:	04a51783          	lh	a5,74(a0)
    80002f8c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f90:	04c56783          	lwu	a5,76(a0)
    80002f94:	e99c                	sd	a5,16(a1)
}
    80002f96:	6422                	ld	s0,8(sp)
    80002f98:	0141                	addi	sp,sp,16
    80002f9a:	8082                	ret

0000000080002f9c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f9c:	457c                	lw	a5,76(a0)
    80002f9e:	0ed7e963          	bltu	a5,a3,80003090 <readi+0xf4>
{
    80002fa2:	7159                	addi	sp,sp,-112
    80002fa4:	f486                	sd	ra,104(sp)
    80002fa6:	f0a2                	sd	s0,96(sp)
    80002fa8:	eca6                	sd	s1,88(sp)
    80002faa:	e8ca                	sd	s2,80(sp)
    80002fac:	e4ce                	sd	s3,72(sp)
    80002fae:	e0d2                	sd	s4,64(sp)
    80002fb0:	fc56                	sd	s5,56(sp)
    80002fb2:	f85a                	sd	s6,48(sp)
    80002fb4:	f45e                	sd	s7,40(sp)
    80002fb6:	f062                	sd	s8,32(sp)
    80002fb8:	ec66                	sd	s9,24(sp)
    80002fba:	e86a                	sd	s10,16(sp)
    80002fbc:	e46e                	sd	s11,8(sp)
    80002fbe:	1880                	addi	s0,sp,112
    80002fc0:	8b2a                	mv	s6,a0
    80002fc2:	8bae                	mv	s7,a1
    80002fc4:	8a32                	mv	s4,a2
    80002fc6:	84b6                	mv	s1,a3
    80002fc8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002fca:	9f35                	addw	a4,a4,a3
    return 0;
    80002fcc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fce:	0ad76063          	bltu	a4,a3,8000306e <readi+0xd2>
  if(off + n > ip->size)
    80002fd2:	00e7f463          	bgeu	a5,a4,80002fda <readi+0x3e>
    n = ip->size - off;
    80002fd6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fda:	0a0a8963          	beqz	s5,8000308c <readi+0xf0>
    80002fde:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fe4:	5c7d                	li	s8,-1
    80002fe6:	a82d                	j	80003020 <readi+0x84>
    80002fe8:	020d1d93          	slli	s11,s10,0x20
    80002fec:	020ddd93          	srli	s11,s11,0x20
    80002ff0:	05890613          	addi	a2,s2,88
    80002ff4:	86ee                	mv	a3,s11
    80002ff6:	963a                	add	a2,a2,a4
    80002ff8:	85d2                	mv	a1,s4
    80002ffa:	855e                	mv	a0,s7
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	a5e080e7          	jalr	-1442(ra) # 80001a5a <either_copyout>
    80003004:	05850d63          	beq	a0,s8,8000305e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003008:	854a                	mv	a0,s2
    8000300a:	fffff097          	auipc	ra,0xfffff
    8000300e:	5f6080e7          	jalr	1526(ra) # 80002600 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003012:	013d09bb          	addw	s3,s10,s3
    80003016:	009d04bb          	addw	s1,s10,s1
    8000301a:	9a6e                	add	s4,s4,s11
    8000301c:	0559f763          	bgeu	s3,s5,8000306a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003020:	00a4d59b          	srliw	a1,s1,0xa
    80003024:	855a                	mv	a0,s6
    80003026:	00000097          	auipc	ra,0x0
    8000302a:	89e080e7          	jalr	-1890(ra) # 800028c4 <bmap>
    8000302e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003032:	cd85                	beqz	a1,8000306a <readi+0xce>
    bp = bread(ip->dev, addr);
    80003034:	000b2503          	lw	a0,0(s6)
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	498080e7          	jalr	1176(ra) # 800024d0 <bread>
    80003040:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003042:	3ff4f713          	andi	a4,s1,1023
    80003046:	40ec87bb          	subw	a5,s9,a4
    8000304a:	413a86bb          	subw	a3,s5,s3
    8000304e:	8d3e                	mv	s10,a5
    80003050:	2781                	sext.w	a5,a5
    80003052:	0006861b          	sext.w	a2,a3
    80003056:	f8f679e3          	bgeu	a2,a5,80002fe8 <readi+0x4c>
    8000305a:	8d36                	mv	s10,a3
    8000305c:	b771                	j	80002fe8 <readi+0x4c>
      brelse(bp);
    8000305e:	854a                	mv	a0,s2
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	5a0080e7          	jalr	1440(ra) # 80002600 <brelse>
      tot = -1;
    80003068:	59fd                	li	s3,-1
  }
  return tot;
    8000306a:	0009851b          	sext.w	a0,s3
}
    8000306e:	70a6                	ld	ra,104(sp)
    80003070:	7406                	ld	s0,96(sp)
    80003072:	64e6                	ld	s1,88(sp)
    80003074:	6946                	ld	s2,80(sp)
    80003076:	69a6                	ld	s3,72(sp)
    80003078:	6a06                	ld	s4,64(sp)
    8000307a:	7ae2                	ld	s5,56(sp)
    8000307c:	7b42                	ld	s6,48(sp)
    8000307e:	7ba2                	ld	s7,40(sp)
    80003080:	7c02                	ld	s8,32(sp)
    80003082:	6ce2                	ld	s9,24(sp)
    80003084:	6d42                	ld	s10,16(sp)
    80003086:	6da2                	ld	s11,8(sp)
    80003088:	6165                	addi	sp,sp,112
    8000308a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000308c:	89d6                	mv	s3,s5
    8000308e:	bff1                	j	8000306a <readi+0xce>
    return 0;
    80003090:	4501                	li	a0,0
}
    80003092:	8082                	ret

0000000080003094 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003094:	457c                	lw	a5,76(a0)
    80003096:	10d7e863          	bltu	a5,a3,800031a6 <writei+0x112>
{
    8000309a:	7159                	addi	sp,sp,-112
    8000309c:	f486                	sd	ra,104(sp)
    8000309e:	f0a2                	sd	s0,96(sp)
    800030a0:	eca6                	sd	s1,88(sp)
    800030a2:	e8ca                	sd	s2,80(sp)
    800030a4:	e4ce                	sd	s3,72(sp)
    800030a6:	e0d2                	sd	s4,64(sp)
    800030a8:	fc56                	sd	s5,56(sp)
    800030aa:	f85a                	sd	s6,48(sp)
    800030ac:	f45e                	sd	s7,40(sp)
    800030ae:	f062                	sd	s8,32(sp)
    800030b0:	ec66                	sd	s9,24(sp)
    800030b2:	e86a                	sd	s10,16(sp)
    800030b4:	e46e                	sd	s11,8(sp)
    800030b6:	1880                	addi	s0,sp,112
    800030b8:	8aaa                	mv	s5,a0
    800030ba:	8bae                	mv	s7,a1
    800030bc:	8a32                	mv	s4,a2
    800030be:	8936                	mv	s2,a3
    800030c0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030c2:	00e687bb          	addw	a5,a3,a4
    800030c6:	0ed7e263          	bltu	a5,a3,800031aa <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030ca:	00043737          	lui	a4,0x43
    800030ce:	0ef76063          	bltu	a4,a5,800031ae <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030d2:	0c0b0863          	beqz	s6,800031a2 <writei+0x10e>
    800030d6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030dc:	5c7d                	li	s8,-1
    800030de:	a091                	j	80003122 <writei+0x8e>
    800030e0:	020d1d93          	slli	s11,s10,0x20
    800030e4:	020ddd93          	srli	s11,s11,0x20
    800030e8:	05848513          	addi	a0,s1,88
    800030ec:	86ee                	mv	a3,s11
    800030ee:	8652                	mv	a2,s4
    800030f0:	85de                	mv	a1,s7
    800030f2:	953a                	add	a0,a0,a4
    800030f4:	fffff097          	auipc	ra,0xfffff
    800030f8:	9bc080e7          	jalr	-1604(ra) # 80001ab0 <either_copyin>
    800030fc:	07850263          	beq	a0,s8,80003160 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003100:	8526                	mv	a0,s1
    80003102:	00000097          	auipc	ra,0x0
    80003106:	788080e7          	jalr	1928(ra) # 8000388a <log_write>
    brelse(bp);
    8000310a:	8526                	mv	a0,s1
    8000310c:	fffff097          	auipc	ra,0xfffff
    80003110:	4f4080e7          	jalr	1268(ra) # 80002600 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003114:	013d09bb          	addw	s3,s10,s3
    80003118:	012d093b          	addw	s2,s10,s2
    8000311c:	9a6e                	add	s4,s4,s11
    8000311e:	0569f663          	bgeu	s3,s6,8000316a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003122:	00a9559b          	srliw	a1,s2,0xa
    80003126:	8556                	mv	a0,s5
    80003128:	fffff097          	auipc	ra,0xfffff
    8000312c:	79c080e7          	jalr	1948(ra) # 800028c4 <bmap>
    80003130:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003134:	c99d                	beqz	a1,8000316a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003136:	000aa503          	lw	a0,0(s5)
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	396080e7          	jalr	918(ra) # 800024d0 <bread>
    80003142:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003144:	3ff97713          	andi	a4,s2,1023
    80003148:	40ec87bb          	subw	a5,s9,a4
    8000314c:	413b06bb          	subw	a3,s6,s3
    80003150:	8d3e                	mv	s10,a5
    80003152:	2781                	sext.w	a5,a5
    80003154:	0006861b          	sext.w	a2,a3
    80003158:	f8f674e3          	bgeu	a2,a5,800030e0 <writei+0x4c>
    8000315c:	8d36                	mv	s10,a3
    8000315e:	b749                	j	800030e0 <writei+0x4c>
      brelse(bp);
    80003160:	8526                	mv	a0,s1
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	49e080e7          	jalr	1182(ra) # 80002600 <brelse>
  }

  if(off > ip->size)
    8000316a:	04caa783          	lw	a5,76(s5)
    8000316e:	0127f463          	bgeu	a5,s2,80003176 <writei+0xe2>
    ip->size = off;
    80003172:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003176:	8556                	mv	a0,s5
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	aa4080e7          	jalr	-1372(ra) # 80002c1c <iupdate>

  return tot;
    80003180:	0009851b          	sext.w	a0,s3
}
    80003184:	70a6                	ld	ra,104(sp)
    80003186:	7406                	ld	s0,96(sp)
    80003188:	64e6                	ld	s1,88(sp)
    8000318a:	6946                	ld	s2,80(sp)
    8000318c:	69a6                	ld	s3,72(sp)
    8000318e:	6a06                	ld	s4,64(sp)
    80003190:	7ae2                	ld	s5,56(sp)
    80003192:	7b42                	ld	s6,48(sp)
    80003194:	7ba2                	ld	s7,40(sp)
    80003196:	7c02                	ld	s8,32(sp)
    80003198:	6ce2                	ld	s9,24(sp)
    8000319a:	6d42                	ld	s10,16(sp)
    8000319c:	6da2                	ld	s11,8(sp)
    8000319e:	6165                	addi	sp,sp,112
    800031a0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031a2:	89da                	mv	s3,s6
    800031a4:	bfc9                	j	80003176 <writei+0xe2>
    return -1;
    800031a6:	557d                	li	a0,-1
}
    800031a8:	8082                	ret
    return -1;
    800031aa:	557d                	li	a0,-1
    800031ac:	bfe1                	j	80003184 <writei+0xf0>
    return -1;
    800031ae:	557d                	li	a0,-1
    800031b0:	bfd1                	j	80003184 <writei+0xf0>

00000000800031b2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031b2:	1141                	addi	sp,sp,-16
    800031b4:	e406                	sd	ra,8(sp)
    800031b6:	e022                	sd	s0,0(sp)
    800031b8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031ba:	4639                	li	a2,14
    800031bc:	ffffd097          	auipc	ra,0xffffd
    800031c0:	10c080e7          	jalr	268(ra) # 800002c8 <strncmp>
}
    800031c4:	60a2                	ld	ra,8(sp)
    800031c6:	6402                	ld	s0,0(sp)
    800031c8:	0141                	addi	sp,sp,16
    800031ca:	8082                	ret

00000000800031cc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031cc:	7139                	addi	sp,sp,-64
    800031ce:	fc06                	sd	ra,56(sp)
    800031d0:	f822                	sd	s0,48(sp)
    800031d2:	f426                	sd	s1,40(sp)
    800031d4:	f04a                	sd	s2,32(sp)
    800031d6:	ec4e                	sd	s3,24(sp)
    800031d8:	e852                	sd	s4,16(sp)
    800031da:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031dc:	04451703          	lh	a4,68(a0)
    800031e0:	4785                	li	a5,1
    800031e2:	00f71a63          	bne	a4,a5,800031f6 <dirlookup+0x2a>
    800031e6:	892a                	mv	s2,a0
    800031e8:	89ae                	mv	s3,a1
    800031ea:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ec:	457c                	lw	a5,76(a0)
    800031ee:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031f0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f2:	e79d                	bnez	a5,80003220 <dirlookup+0x54>
    800031f4:	a8a5                	j	8000326c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031f6:	00005517          	auipc	a0,0x5
    800031fa:	37a50513          	addi	a0,a0,890 # 80008570 <syscalls+0x1a0>
    800031fe:	00003097          	auipc	ra,0x3
    80003202:	b9e080e7          	jalr	-1122(ra) # 80005d9c <panic>
      panic("dirlookup read");
    80003206:	00005517          	auipc	a0,0x5
    8000320a:	38250513          	addi	a0,a0,898 # 80008588 <syscalls+0x1b8>
    8000320e:	00003097          	auipc	ra,0x3
    80003212:	b8e080e7          	jalr	-1138(ra) # 80005d9c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003216:	24c1                	addiw	s1,s1,16
    80003218:	04c92783          	lw	a5,76(s2)
    8000321c:	04f4f763          	bgeu	s1,a5,8000326a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003220:	4741                	li	a4,16
    80003222:	86a6                	mv	a3,s1
    80003224:	fc040613          	addi	a2,s0,-64
    80003228:	4581                	li	a1,0
    8000322a:	854a                	mv	a0,s2
    8000322c:	00000097          	auipc	ra,0x0
    80003230:	d70080e7          	jalr	-656(ra) # 80002f9c <readi>
    80003234:	47c1                	li	a5,16
    80003236:	fcf518e3          	bne	a0,a5,80003206 <dirlookup+0x3a>
    if(de.inum == 0)
    8000323a:	fc045783          	lhu	a5,-64(s0)
    8000323e:	dfe1                	beqz	a5,80003216 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003240:	fc240593          	addi	a1,s0,-62
    80003244:	854e                	mv	a0,s3
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	f6c080e7          	jalr	-148(ra) # 800031b2 <namecmp>
    8000324e:	f561                	bnez	a0,80003216 <dirlookup+0x4a>
      if(poff)
    80003250:	000a0463          	beqz	s4,80003258 <dirlookup+0x8c>
        *poff = off;
    80003254:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003258:	fc045583          	lhu	a1,-64(s0)
    8000325c:	00092503          	lw	a0,0(s2)
    80003260:	fffff097          	auipc	ra,0xfffff
    80003264:	74e080e7          	jalr	1870(ra) # 800029ae <iget>
    80003268:	a011                	j	8000326c <dirlookup+0xa0>
  return 0;
    8000326a:	4501                	li	a0,0
}
    8000326c:	70e2                	ld	ra,56(sp)
    8000326e:	7442                	ld	s0,48(sp)
    80003270:	74a2                	ld	s1,40(sp)
    80003272:	7902                	ld	s2,32(sp)
    80003274:	69e2                	ld	s3,24(sp)
    80003276:	6a42                	ld	s4,16(sp)
    80003278:	6121                	addi	sp,sp,64
    8000327a:	8082                	ret

000000008000327c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000327c:	711d                	addi	sp,sp,-96
    8000327e:	ec86                	sd	ra,88(sp)
    80003280:	e8a2                	sd	s0,80(sp)
    80003282:	e4a6                	sd	s1,72(sp)
    80003284:	e0ca                	sd	s2,64(sp)
    80003286:	fc4e                	sd	s3,56(sp)
    80003288:	f852                	sd	s4,48(sp)
    8000328a:	f456                	sd	s5,40(sp)
    8000328c:	f05a                	sd	s6,32(sp)
    8000328e:	ec5e                	sd	s7,24(sp)
    80003290:	e862                	sd	s8,16(sp)
    80003292:	e466                	sd	s9,8(sp)
    80003294:	e06a                	sd	s10,0(sp)
    80003296:	1080                	addi	s0,sp,96
    80003298:	84aa                	mv	s1,a0
    8000329a:	8b2e                	mv	s6,a1
    8000329c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000329e:	00054703          	lbu	a4,0(a0)
    800032a2:	02f00793          	li	a5,47
    800032a6:	02f70363          	beq	a4,a5,800032cc <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032aa:	ffffe097          	auipc	ra,0xffffe
    800032ae:	d00080e7          	jalr	-768(ra) # 80000faa <myproc>
    800032b2:	15053503          	ld	a0,336(a0)
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	9f4080e7          	jalr	-1548(ra) # 80002caa <idup>
    800032be:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032c0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032c4:	4cb5                	li	s9,13
  len = path - s;
    800032c6:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032c8:	4c05                	li	s8,1
    800032ca:	a87d                	j	80003388 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800032cc:	4585                	li	a1,1
    800032ce:	4505                	li	a0,1
    800032d0:	fffff097          	auipc	ra,0xfffff
    800032d4:	6de080e7          	jalr	1758(ra) # 800029ae <iget>
    800032d8:	8a2a                	mv	s4,a0
    800032da:	b7dd                	j	800032c0 <namex+0x44>
      iunlockput(ip);
    800032dc:	8552                	mv	a0,s4
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	c6c080e7          	jalr	-916(ra) # 80002f4a <iunlockput>
      return 0;
    800032e6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032e8:	8552                	mv	a0,s4
    800032ea:	60e6                	ld	ra,88(sp)
    800032ec:	6446                	ld	s0,80(sp)
    800032ee:	64a6                	ld	s1,72(sp)
    800032f0:	6906                	ld	s2,64(sp)
    800032f2:	79e2                	ld	s3,56(sp)
    800032f4:	7a42                	ld	s4,48(sp)
    800032f6:	7aa2                	ld	s5,40(sp)
    800032f8:	7b02                	ld	s6,32(sp)
    800032fa:	6be2                	ld	s7,24(sp)
    800032fc:	6c42                	ld	s8,16(sp)
    800032fe:	6ca2                	ld	s9,8(sp)
    80003300:	6d02                	ld	s10,0(sp)
    80003302:	6125                	addi	sp,sp,96
    80003304:	8082                	ret
      iunlock(ip);
    80003306:	8552                	mv	a0,s4
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	aa2080e7          	jalr	-1374(ra) # 80002daa <iunlock>
      return ip;
    80003310:	bfe1                	j	800032e8 <namex+0x6c>
      iunlockput(ip);
    80003312:	8552                	mv	a0,s4
    80003314:	00000097          	auipc	ra,0x0
    80003318:	c36080e7          	jalr	-970(ra) # 80002f4a <iunlockput>
      return 0;
    8000331c:	8a4e                	mv	s4,s3
    8000331e:	b7e9                	j	800032e8 <namex+0x6c>
  len = path - s;
    80003320:	40998633          	sub	a2,s3,s1
    80003324:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003328:	09acd863          	bge	s9,s10,800033b8 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000332c:	4639                	li	a2,14
    8000332e:	85a6                	mv	a1,s1
    80003330:	8556                	mv	a0,s5
    80003332:	ffffd097          	auipc	ra,0xffffd
    80003336:	f22080e7          	jalr	-222(ra) # 80000254 <memmove>
    8000333a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000333c:	0004c783          	lbu	a5,0(s1)
    80003340:	01279763          	bne	a5,s2,8000334e <namex+0xd2>
    path++;
    80003344:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003346:	0004c783          	lbu	a5,0(s1)
    8000334a:	ff278de3          	beq	a5,s2,80003344 <namex+0xc8>
    ilock(ip);
    8000334e:	8552                	mv	a0,s4
    80003350:	00000097          	auipc	ra,0x0
    80003354:	998080e7          	jalr	-1640(ra) # 80002ce8 <ilock>
    if(ip->type != T_DIR){
    80003358:	044a1783          	lh	a5,68(s4)
    8000335c:	f98790e3          	bne	a5,s8,800032dc <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003360:	000b0563          	beqz	s6,8000336a <namex+0xee>
    80003364:	0004c783          	lbu	a5,0(s1)
    80003368:	dfd9                	beqz	a5,80003306 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000336a:	865e                	mv	a2,s7
    8000336c:	85d6                	mv	a1,s5
    8000336e:	8552                	mv	a0,s4
    80003370:	00000097          	auipc	ra,0x0
    80003374:	e5c080e7          	jalr	-420(ra) # 800031cc <dirlookup>
    80003378:	89aa                	mv	s3,a0
    8000337a:	dd41                	beqz	a0,80003312 <namex+0x96>
    iunlockput(ip);
    8000337c:	8552                	mv	a0,s4
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	bcc080e7          	jalr	-1076(ra) # 80002f4a <iunlockput>
    ip = next;
    80003386:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003388:	0004c783          	lbu	a5,0(s1)
    8000338c:	01279763          	bne	a5,s2,8000339a <namex+0x11e>
    path++;
    80003390:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003392:	0004c783          	lbu	a5,0(s1)
    80003396:	ff278de3          	beq	a5,s2,80003390 <namex+0x114>
  if(*path == 0)
    8000339a:	cb9d                	beqz	a5,800033d0 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000339c:	0004c783          	lbu	a5,0(s1)
    800033a0:	89a6                	mv	s3,s1
  len = path - s;
    800033a2:	8d5e                	mv	s10,s7
    800033a4:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033a6:	01278963          	beq	a5,s2,800033b8 <namex+0x13c>
    800033aa:	dbbd                	beqz	a5,80003320 <namex+0xa4>
    path++;
    800033ac:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033ae:	0009c783          	lbu	a5,0(s3)
    800033b2:	ff279ce3          	bne	a5,s2,800033aa <namex+0x12e>
    800033b6:	b7ad                	j	80003320 <namex+0xa4>
    memmove(name, s, len);
    800033b8:	2601                	sext.w	a2,a2
    800033ba:	85a6                	mv	a1,s1
    800033bc:	8556                	mv	a0,s5
    800033be:	ffffd097          	auipc	ra,0xffffd
    800033c2:	e96080e7          	jalr	-362(ra) # 80000254 <memmove>
    name[len] = 0;
    800033c6:	9d56                	add	s10,s10,s5
    800033c8:	000d0023          	sb	zero,0(s10)
    800033cc:	84ce                	mv	s1,s3
    800033ce:	b7bd                	j	8000333c <namex+0xc0>
  if(nameiparent){
    800033d0:	f00b0ce3          	beqz	s6,800032e8 <namex+0x6c>
    iput(ip);
    800033d4:	8552                	mv	a0,s4
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	acc080e7          	jalr	-1332(ra) # 80002ea2 <iput>
    return 0;
    800033de:	4a01                	li	s4,0
    800033e0:	b721                	j	800032e8 <namex+0x6c>

00000000800033e2 <dirlink>:
{
    800033e2:	7139                	addi	sp,sp,-64
    800033e4:	fc06                	sd	ra,56(sp)
    800033e6:	f822                	sd	s0,48(sp)
    800033e8:	f426                	sd	s1,40(sp)
    800033ea:	f04a                	sd	s2,32(sp)
    800033ec:	ec4e                	sd	s3,24(sp)
    800033ee:	e852                	sd	s4,16(sp)
    800033f0:	0080                	addi	s0,sp,64
    800033f2:	892a                	mv	s2,a0
    800033f4:	8a2e                	mv	s4,a1
    800033f6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033f8:	4601                	li	a2,0
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	dd2080e7          	jalr	-558(ra) # 800031cc <dirlookup>
    80003402:	e93d                	bnez	a0,80003478 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003404:	04c92483          	lw	s1,76(s2)
    80003408:	c49d                	beqz	s1,80003436 <dirlink+0x54>
    8000340a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000340c:	4741                	li	a4,16
    8000340e:	86a6                	mv	a3,s1
    80003410:	fc040613          	addi	a2,s0,-64
    80003414:	4581                	li	a1,0
    80003416:	854a                	mv	a0,s2
    80003418:	00000097          	auipc	ra,0x0
    8000341c:	b84080e7          	jalr	-1148(ra) # 80002f9c <readi>
    80003420:	47c1                	li	a5,16
    80003422:	06f51163          	bne	a0,a5,80003484 <dirlink+0xa2>
    if(de.inum == 0)
    80003426:	fc045783          	lhu	a5,-64(s0)
    8000342a:	c791                	beqz	a5,80003436 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000342c:	24c1                	addiw	s1,s1,16
    8000342e:	04c92783          	lw	a5,76(s2)
    80003432:	fcf4ede3          	bltu	s1,a5,8000340c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003436:	4639                	li	a2,14
    80003438:	85d2                	mv	a1,s4
    8000343a:	fc240513          	addi	a0,s0,-62
    8000343e:	ffffd097          	auipc	ra,0xffffd
    80003442:	ec6080e7          	jalr	-314(ra) # 80000304 <strncpy>
  de.inum = inum;
    80003446:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000344a:	4741                	li	a4,16
    8000344c:	86a6                	mv	a3,s1
    8000344e:	fc040613          	addi	a2,s0,-64
    80003452:	4581                	li	a1,0
    80003454:	854a                	mv	a0,s2
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	c3e080e7          	jalr	-962(ra) # 80003094 <writei>
    8000345e:	1541                	addi	a0,a0,-16
    80003460:	00a03533          	snez	a0,a0
    80003464:	40a00533          	neg	a0,a0
}
    80003468:	70e2                	ld	ra,56(sp)
    8000346a:	7442                	ld	s0,48(sp)
    8000346c:	74a2                	ld	s1,40(sp)
    8000346e:	7902                	ld	s2,32(sp)
    80003470:	69e2                	ld	s3,24(sp)
    80003472:	6a42                	ld	s4,16(sp)
    80003474:	6121                	addi	sp,sp,64
    80003476:	8082                	ret
    iput(ip);
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	a2a080e7          	jalr	-1494(ra) # 80002ea2 <iput>
    return -1;
    80003480:	557d                	li	a0,-1
    80003482:	b7dd                	j	80003468 <dirlink+0x86>
      panic("dirlink read");
    80003484:	00005517          	auipc	a0,0x5
    80003488:	11450513          	addi	a0,a0,276 # 80008598 <syscalls+0x1c8>
    8000348c:	00003097          	auipc	ra,0x3
    80003490:	910080e7          	jalr	-1776(ra) # 80005d9c <panic>

0000000080003494 <namei>:

struct inode*
namei(char *path)
{
    80003494:	1101                	addi	sp,sp,-32
    80003496:	ec06                	sd	ra,24(sp)
    80003498:	e822                	sd	s0,16(sp)
    8000349a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000349c:	fe040613          	addi	a2,s0,-32
    800034a0:	4581                	li	a1,0
    800034a2:	00000097          	auipc	ra,0x0
    800034a6:	dda080e7          	jalr	-550(ra) # 8000327c <namex>
}
    800034aa:	60e2                	ld	ra,24(sp)
    800034ac:	6442                	ld	s0,16(sp)
    800034ae:	6105                	addi	sp,sp,32
    800034b0:	8082                	ret

00000000800034b2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034b2:	1141                	addi	sp,sp,-16
    800034b4:	e406                	sd	ra,8(sp)
    800034b6:	e022                	sd	s0,0(sp)
    800034b8:	0800                	addi	s0,sp,16
    800034ba:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034bc:	4585                	li	a1,1
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	dbe080e7          	jalr	-578(ra) # 8000327c <namex>
}
    800034c6:	60a2                	ld	ra,8(sp)
    800034c8:	6402                	ld	s0,0(sp)
    800034ca:	0141                	addi	sp,sp,16
    800034cc:	8082                	ret

00000000800034ce <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034ce:	1101                	addi	sp,sp,-32
    800034d0:	ec06                	sd	ra,24(sp)
    800034d2:	e822                	sd	s0,16(sp)
    800034d4:	e426                	sd	s1,8(sp)
    800034d6:	e04a                	sd	s2,0(sp)
    800034d8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034da:	00235917          	auipc	s2,0x235
    800034de:	40e90913          	addi	s2,s2,1038 # 802388e8 <log>
    800034e2:	01892583          	lw	a1,24(s2)
    800034e6:	02892503          	lw	a0,40(s2)
    800034ea:	fffff097          	auipc	ra,0xfffff
    800034ee:	fe6080e7          	jalr	-26(ra) # 800024d0 <bread>
    800034f2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034f4:	02c92683          	lw	a3,44(s2)
    800034f8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034fa:	02d05863          	blez	a3,8000352a <write_head+0x5c>
    800034fe:	00235797          	auipc	a5,0x235
    80003502:	41a78793          	addi	a5,a5,1050 # 80238918 <log+0x30>
    80003506:	05c50713          	addi	a4,a0,92
    8000350a:	36fd                	addiw	a3,a3,-1
    8000350c:	02069613          	slli	a2,a3,0x20
    80003510:	01e65693          	srli	a3,a2,0x1e
    80003514:	00235617          	auipc	a2,0x235
    80003518:	40860613          	addi	a2,a2,1032 # 8023891c <log+0x34>
    8000351c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000351e:	4390                	lw	a2,0(a5)
    80003520:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003522:	0791                	addi	a5,a5,4
    80003524:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003526:	fed79ce3          	bne	a5,a3,8000351e <write_head+0x50>
  }
  bwrite(buf);
    8000352a:	8526                	mv	a0,s1
    8000352c:	fffff097          	auipc	ra,0xfffff
    80003530:	096080e7          	jalr	150(ra) # 800025c2 <bwrite>
  brelse(buf);
    80003534:	8526                	mv	a0,s1
    80003536:	fffff097          	auipc	ra,0xfffff
    8000353a:	0ca080e7          	jalr	202(ra) # 80002600 <brelse>
}
    8000353e:	60e2                	ld	ra,24(sp)
    80003540:	6442                	ld	s0,16(sp)
    80003542:	64a2                	ld	s1,8(sp)
    80003544:	6902                	ld	s2,0(sp)
    80003546:	6105                	addi	sp,sp,32
    80003548:	8082                	ret

000000008000354a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000354a:	00235797          	auipc	a5,0x235
    8000354e:	3ca7a783          	lw	a5,970(a5) # 80238914 <log+0x2c>
    80003552:	0af05d63          	blez	a5,8000360c <install_trans+0xc2>
{
    80003556:	7139                	addi	sp,sp,-64
    80003558:	fc06                	sd	ra,56(sp)
    8000355a:	f822                	sd	s0,48(sp)
    8000355c:	f426                	sd	s1,40(sp)
    8000355e:	f04a                	sd	s2,32(sp)
    80003560:	ec4e                	sd	s3,24(sp)
    80003562:	e852                	sd	s4,16(sp)
    80003564:	e456                	sd	s5,8(sp)
    80003566:	e05a                	sd	s6,0(sp)
    80003568:	0080                	addi	s0,sp,64
    8000356a:	8b2a                	mv	s6,a0
    8000356c:	00235a97          	auipc	s5,0x235
    80003570:	3aca8a93          	addi	s5,s5,940 # 80238918 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003574:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003576:	00235997          	auipc	s3,0x235
    8000357a:	37298993          	addi	s3,s3,882 # 802388e8 <log>
    8000357e:	a00d                	j	800035a0 <install_trans+0x56>
    brelse(lbuf);
    80003580:	854a                	mv	a0,s2
    80003582:	fffff097          	auipc	ra,0xfffff
    80003586:	07e080e7          	jalr	126(ra) # 80002600 <brelse>
    brelse(dbuf);
    8000358a:	8526                	mv	a0,s1
    8000358c:	fffff097          	auipc	ra,0xfffff
    80003590:	074080e7          	jalr	116(ra) # 80002600 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003594:	2a05                	addiw	s4,s4,1
    80003596:	0a91                	addi	s5,s5,4
    80003598:	02c9a783          	lw	a5,44(s3)
    8000359c:	04fa5e63          	bge	s4,a5,800035f8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035a0:	0189a583          	lw	a1,24(s3)
    800035a4:	014585bb          	addw	a1,a1,s4
    800035a8:	2585                	addiw	a1,a1,1
    800035aa:	0289a503          	lw	a0,40(s3)
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	f22080e7          	jalr	-222(ra) # 800024d0 <bread>
    800035b6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035b8:	000aa583          	lw	a1,0(s5)
    800035bc:	0289a503          	lw	a0,40(s3)
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	f10080e7          	jalr	-240(ra) # 800024d0 <bread>
    800035c8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035ca:	40000613          	li	a2,1024
    800035ce:	05890593          	addi	a1,s2,88
    800035d2:	05850513          	addi	a0,a0,88
    800035d6:	ffffd097          	auipc	ra,0xffffd
    800035da:	c7e080e7          	jalr	-898(ra) # 80000254 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035de:	8526                	mv	a0,s1
    800035e0:	fffff097          	auipc	ra,0xfffff
    800035e4:	fe2080e7          	jalr	-30(ra) # 800025c2 <bwrite>
    if(recovering == 0)
    800035e8:	f80b1ce3          	bnez	s6,80003580 <install_trans+0x36>
      bunpin(dbuf);
    800035ec:	8526                	mv	a0,s1
    800035ee:	fffff097          	auipc	ra,0xfffff
    800035f2:	0ec080e7          	jalr	236(ra) # 800026da <bunpin>
    800035f6:	b769                	j	80003580 <install_trans+0x36>
}
    800035f8:	70e2                	ld	ra,56(sp)
    800035fa:	7442                	ld	s0,48(sp)
    800035fc:	74a2                	ld	s1,40(sp)
    800035fe:	7902                	ld	s2,32(sp)
    80003600:	69e2                	ld	s3,24(sp)
    80003602:	6a42                	ld	s4,16(sp)
    80003604:	6aa2                	ld	s5,8(sp)
    80003606:	6b02                	ld	s6,0(sp)
    80003608:	6121                	addi	sp,sp,64
    8000360a:	8082                	ret
    8000360c:	8082                	ret

000000008000360e <initlog>:
{
    8000360e:	7179                	addi	sp,sp,-48
    80003610:	f406                	sd	ra,40(sp)
    80003612:	f022                	sd	s0,32(sp)
    80003614:	ec26                	sd	s1,24(sp)
    80003616:	e84a                	sd	s2,16(sp)
    80003618:	e44e                	sd	s3,8(sp)
    8000361a:	1800                	addi	s0,sp,48
    8000361c:	892a                	mv	s2,a0
    8000361e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003620:	00235497          	auipc	s1,0x235
    80003624:	2c848493          	addi	s1,s1,712 # 802388e8 <log>
    80003628:	00005597          	auipc	a1,0x5
    8000362c:	f8058593          	addi	a1,a1,-128 # 800085a8 <syscalls+0x1d8>
    80003630:	8526                	mv	a0,s1
    80003632:	00003097          	auipc	ra,0x3
    80003636:	c12080e7          	jalr	-1006(ra) # 80006244 <initlock>
  log.start = sb->logstart;
    8000363a:	0149a583          	lw	a1,20(s3)
    8000363e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003640:	0109a783          	lw	a5,16(s3)
    80003644:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003646:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000364a:	854a                	mv	a0,s2
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	e84080e7          	jalr	-380(ra) # 800024d0 <bread>
  log.lh.n = lh->n;
    80003654:	4d34                	lw	a3,88(a0)
    80003656:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003658:	02d05663          	blez	a3,80003684 <initlog+0x76>
    8000365c:	05c50793          	addi	a5,a0,92
    80003660:	00235717          	auipc	a4,0x235
    80003664:	2b870713          	addi	a4,a4,696 # 80238918 <log+0x30>
    80003668:	36fd                	addiw	a3,a3,-1
    8000366a:	02069613          	slli	a2,a3,0x20
    8000366e:	01e65693          	srli	a3,a2,0x1e
    80003672:	06050613          	addi	a2,a0,96
    80003676:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003678:	4390                	lw	a2,0(a5)
    8000367a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000367c:	0791                	addi	a5,a5,4
    8000367e:	0711                	addi	a4,a4,4
    80003680:	fed79ce3          	bne	a5,a3,80003678 <initlog+0x6a>
  brelse(buf);
    80003684:	fffff097          	auipc	ra,0xfffff
    80003688:	f7c080e7          	jalr	-132(ra) # 80002600 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000368c:	4505                	li	a0,1
    8000368e:	00000097          	auipc	ra,0x0
    80003692:	ebc080e7          	jalr	-324(ra) # 8000354a <install_trans>
  log.lh.n = 0;
    80003696:	00235797          	auipc	a5,0x235
    8000369a:	2607af23          	sw	zero,638(a5) # 80238914 <log+0x2c>
  write_head(); // clear the log
    8000369e:	00000097          	auipc	ra,0x0
    800036a2:	e30080e7          	jalr	-464(ra) # 800034ce <write_head>
}
    800036a6:	70a2                	ld	ra,40(sp)
    800036a8:	7402                	ld	s0,32(sp)
    800036aa:	64e2                	ld	s1,24(sp)
    800036ac:	6942                	ld	s2,16(sp)
    800036ae:	69a2                	ld	s3,8(sp)
    800036b0:	6145                	addi	sp,sp,48
    800036b2:	8082                	ret

00000000800036b4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036b4:	1101                	addi	sp,sp,-32
    800036b6:	ec06                	sd	ra,24(sp)
    800036b8:	e822                	sd	s0,16(sp)
    800036ba:	e426                	sd	s1,8(sp)
    800036bc:	e04a                	sd	s2,0(sp)
    800036be:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036c0:	00235517          	auipc	a0,0x235
    800036c4:	22850513          	addi	a0,a0,552 # 802388e8 <log>
    800036c8:	00003097          	auipc	ra,0x3
    800036cc:	c0c080e7          	jalr	-1012(ra) # 800062d4 <acquire>
  while(1){
    if(log.committing){
    800036d0:	00235497          	auipc	s1,0x235
    800036d4:	21848493          	addi	s1,s1,536 # 802388e8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036d8:	4979                	li	s2,30
    800036da:	a039                	j	800036e8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036dc:	85a6                	mv	a1,s1
    800036de:	8526                	mv	a0,s1
    800036e0:	ffffe097          	auipc	ra,0xffffe
    800036e4:	f72080e7          	jalr	-142(ra) # 80001652 <sleep>
    if(log.committing){
    800036e8:	50dc                	lw	a5,36(s1)
    800036ea:	fbed                	bnez	a5,800036dc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036ec:	5098                	lw	a4,32(s1)
    800036ee:	2705                	addiw	a4,a4,1
    800036f0:	0007069b          	sext.w	a3,a4
    800036f4:	0027179b          	slliw	a5,a4,0x2
    800036f8:	9fb9                	addw	a5,a5,a4
    800036fa:	0017979b          	slliw	a5,a5,0x1
    800036fe:	54d8                	lw	a4,44(s1)
    80003700:	9fb9                	addw	a5,a5,a4
    80003702:	00f95963          	bge	s2,a5,80003714 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003706:	85a6                	mv	a1,s1
    80003708:	8526                	mv	a0,s1
    8000370a:	ffffe097          	auipc	ra,0xffffe
    8000370e:	f48080e7          	jalr	-184(ra) # 80001652 <sleep>
    80003712:	bfd9                	j	800036e8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003714:	00235517          	auipc	a0,0x235
    80003718:	1d450513          	addi	a0,a0,468 # 802388e8 <log>
    8000371c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000371e:	00003097          	auipc	ra,0x3
    80003722:	c6a080e7          	jalr	-918(ra) # 80006388 <release>
      break;
    }
  }
}
    80003726:	60e2                	ld	ra,24(sp)
    80003728:	6442                	ld	s0,16(sp)
    8000372a:	64a2                	ld	s1,8(sp)
    8000372c:	6902                	ld	s2,0(sp)
    8000372e:	6105                	addi	sp,sp,32
    80003730:	8082                	ret

0000000080003732 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003732:	7139                	addi	sp,sp,-64
    80003734:	fc06                	sd	ra,56(sp)
    80003736:	f822                	sd	s0,48(sp)
    80003738:	f426                	sd	s1,40(sp)
    8000373a:	f04a                	sd	s2,32(sp)
    8000373c:	ec4e                	sd	s3,24(sp)
    8000373e:	e852                	sd	s4,16(sp)
    80003740:	e456                	sd	s5,8(sp)
    80003742:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003744:	00235497          	auipc	s1,0x235
    80003748:	1a448493          	addi	s1,s1,420 # 802388e8 <log>
    8000374c:	8526                	mv	a0,s1
    8000374e:	00003097          	auipc	ra,0x3
    80003752:	b86080e7          	jalr	-1146(ra) # 800062d4 <acquire>
  log.outstanding -= 1;
    80003756:	509c                	lw	a5,32(s1)
    80003758:	37fd                	addiw	a5,a5,-1
    8000375a:	0007891b          	sext.w	s2,a5
    8000375e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003760:	50dc                	lw	a5,36(s1)
    80003762:	e7b9                	bnez	a5,800037b0 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003764:	04091e63          	bnez	s2,800037c0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003768:	00235497          	auipc	s1,0x235
    8000376c:	18048493          	addi	s1,s1,384 # 802388e8 <log>
    80003770:	4785                	li	a5,1
    80003772:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003774:	8526                	mv	a0,s1
    80003776:	00003097          	auipc	ra,0x3
    8000377a:	c12080e7          	jalr	-1006(ra) # 80006388 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000377e:	54dc                	lw	a5,44(s1)
    80003780:	06f04763          	bgtz	a5,800037ee <end_op+0xbc>
    acquire(&log.lock);
    80003784:	00235497          	auipc	s1,0x235
    80003788:	16448493          	addi	s1,s1,356 # 802388e8 <log>
    8000378c:	8526                	mv	a0,s1
    8000378e:	00003097          	auipc	ra,0x3
    80003792:	b46080e7          	jalr	-1210(ra) # 800062d4 <acquire>
    log.committing = 0;
    80003796:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000379a:	8526                	mv	a0,s1
    8000379c:	ffffe097          	auipc	ra,0xffffe
    800037a0:	f1a080e7          	jalr	-230(ra) # 800016b6 <wakeup>
    release(&log.lock);
    800037a4:	8526                	mv	a0,s1
    800037a6:	00003097          	auipc	ra,0x3
    800037aa:	be2080e7          	jalr	-1054(ra) # 80006388 <release>
}
    800037ae:	a03d                	j	800037dc <end_op+0xaa>
    panic("log.committing");
    800037b0:	00005517          	auipc	a0,0x5
    800037b4:	e0050513          	addi	a0,a0,-512 # 800085b0 <syscalls+0x1e0>
    800037b8:	00002097          	auipc	ra,0x2
    800037bc:	5e4080e7          	jalr	1508(ra) # 80005d9c <panic>
    wakeup(&log);
    800037c0:	00235497          	auipc	s1,0x235
    800037c4:	12848493          	addi	s1,s1,296 # 802388e8 <log>
    800037c8:	8526                	mv	a0,s1
    800037ca:	ffffe097          	auipc	ra,0xffffe
    800037ce:	eec080e7          	jalr	-276(ra) # 800016b6 <wakeup>
  release(&log.lock);
    800037d2:	8526                	mv	a0,s1
    800037d4:	00003097          	auipc	ra,0x3
    800037d8:	bb4080e7          	jalr	-1100(ra) # 80006388 <release>
}
    800037dc:	70e2                	ld	ra,56(sp)
    800037de:	7442                	ld	s0,48(sp)
    800037e0:	74a2                	ld	s1,40(sp)
    800037e2:	7902                	ld	s2,32(sp)
    800037e4:	69e2                	ld	s3,24(sp)
    800037e6:	6a42                	ld	s4,16(sp)
    800037e8:	6aa2                	ld	s5,8(sp)
    800037ea:	6121                	addi	sp,sp,64
    800037ec:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ee:	00235a97          	auipc	s5,0x235
    800037f2:	12aa8a93          	addi	s5,s5,298 # 80238918 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037f6:	00235a17          	auipc	s4,0x235
    800037fa:	0f2a0a13          	addi	s4,s4,242 # 802388e8 <log>
    800037fe:	018a2583          	lw	a1,24(s4)
    80003802:	012585bb          	addw	a1,a1,s2
    80003806:	2585                	addiw	a1,a1,1
    80003808:	028a2503          	lw	a0,40(s4)
    8000380c:	fffff097          	auipc	ra,0xfffff
    80003810:	cc4080e7          	jalr	-828(ra) # 800024d0 <bread>
    80003814:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003816:	000aa583          	lw	a1,0(s5)
    8000381a:	028a2503          	lw	a0,40(s4)
    8000381e:	fffff097          	auipc	ra,0xfffff
    80003822:	cb2080e7          	jalr	-846(ra) # 800024d0 <bread>
    80003826:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003828:	40000613          	li	a2,1024
    8000382c:	05850593          	addi	a1,a0,88
    80003830:	05848513          	addi	a0,s1,88
    80003834:	ffffd097          	auipc	ra,0xffffd
    80003838:	a20080e7          	jalr	-1504(ra) # 80000254 <memmove>
    bwrite(to);  // write the log
    8000383c:	8526                	mv	a0,s1
    8000383e:	fffff097          	auipc	ra,0xfffff
    80003842:	d84080e7          	jalr	-636(ra) # 800025c2 <bwrite>
    brelse(from);
    80003846:	854e                	mv	a0,s3
    80003848:	fffff097          	auipc	ra,0xfffff
    8000384c:	db8080e7          	jalr	-584(ra) # 80002600 <brelse>
    brelse(to);
    80003850:	8526                	mv	a0,s1
    80003852:	fffff097          	auipc	ra,0xfffff
    80003856:	dae080e7          	jalr	-594(ra) # 80002600 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000385a:	2905                	addiw	s2,s2,1
    8000385c:	0a91                	addi	s5,s5,4
    8000385e:	02ca2783          	lw	a5,44(s4)
    80003862:	f8f94ee3          	blt	s2,a5,800037fe <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003866:	00000097          	auipc	ra,0x0
    8000386a:	c68080e7          	jalr	-920(ra) # 800034ce <write_head>
    install_trans(0); // Now install writes to home locations
    8000386e:	4501                	li	a0,0
    80003870:	00000097          	auipc	ra,0x0
    80003874:	cda080e7          	jalr	-806(ra) # 8000354a <install_trans>
    log.lh.n = 0;
    80003878:	00235797          	auipc	a5,0x235
    8000387c:	0807ae23          	sw	zero,156(a5) # 80238914 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003880:	00000097          	auipc	ra,0x0
    80003884:	c4e080e7          	jalr	-946(ra) # 800034ce <write_head>
    80003888:	bdf5                	j	80003784 <end_op+0x52>

000000008000388a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000388a:	1101                	addi	sp,sp,-32
    8000388c:	ec06                	sd	ra,24(sp)
    8000388e:	e822                	sd	s0,16(sp)
    80003890:	e426                	sd	s1,8(sp)
    80003892:	e04a                	sd	s2,0(sp)
    80003894:	1000                	addi	s0,sp,32
    80003896:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003898:	00235917          	auipc	s2,0x235
    8000389c:	05090913          	addi	s2,s2,80 # 802388e8 <log>
    800038a0:	854a                	mv	a0,s2
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	a32080e7          	jalr	-1486(ra) # 800062d4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038aa:	02c92603          	lw	a2,44(s2)
    800038ae:	47f5                	li	a5,29
    800038b0:	06c7c563          	blt	a5,a2,8000391a <log_write+0x90>
    800038b4:	00235797          	auipc	a5,0x235
    800038b8:	0507a783          	lw	a5,80(a5) # 80238904 <log+0x1c>
    800038bc:	37fd                	addiw	a5,a5,-1
    800038be:	04f65e63          	bge	a2,a5,8000391a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038c2:	00235797          	auipc	a5,0x235
    800038c6:	0467a783          	lw	a5,70(a5) # 80238908 <log+0x20>
    800038ca:	06f05063          	blez	a5,8000392a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038ce:	4781                	li	a5,0
    800038d0:	06c05563          	blez	a2,8000393a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038d4:	44cc                	lw	a1,12(s1)
    800038d6:	00235717          	auipc	a4,0x235
    800038da:	04270713          	addi	a4,a4,66 # 80238918 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038de:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038e0:	4314                	lw	a3,0(a4)
    800038e2:	04b68c63          	beq	a3,a1,8000393a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038e6:	2785                	addiw	a5,a5,1
    800038e8:	0711                	addi	a4,a4,4
    800038ea:	fef61be3          	bne	a2,a5,800038e0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038ee:	0621                	addi	a2,a2,8
    800038f0:	060a                	slli	a2,a2,0x2
    800038f2:	00235797          	auipc	a5,0x235
    800038f6:	ff678793          	addi	a5,a5,-10 # 802388e8 <log>
    800038fa:	97b2                	add	a5,a5,a2
    800038fc:	44d8                	lw	a4,12(s1)
    800038fe:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003900:	8526                	mv	a0,s1
    80003902:	fffff097          	auipc	ra,0xfffff
    80003906:	d9c080e7          	jalr	-612(ra) # 8000269e <bpin>
    log.lh.n++;
    8000390a:	00235717          	auipc	a4,0x235
    8000390e:	fde70713          	addi	a4,a4,-34 # 802388e8 <log>
    80003912:	575c                	lw	a5,44(a4)
    80003914:	2785                	addiw	a5,a5,1
    80003916:	d75c                	sw	a5,44(a4)
    80003918:	a82d                	j	80003952 <log_write+0xc8>
    panic("too big a transaction");
    8000391a:	00005517          	auipc	a0,0x5
    8000391e:	ca650513          	addi	a0,a0,-858 # 800085c0 <syscalls+0x1f0>
    80003922:	00002097          	auipc	ra,0x2
    80003926:	47a080e7          	jalr	1146(ra) # 80005d9c <panic>
    panic("log_write outside of trans");
    8000392a:	00005517          	auipc	a0,0x5
    8000392e:	cae50513          	addi	a0,a0,-850 # 800085d8 <syscalls+0x208>
    80003932:	00002097          	auipc	ra,0x2
    80003936:	46a080e7          	jalr	1130(ra) # 80005d9c <panic>
  log.lh.block[i] = b->blockno;
    8000393a:	00878693          	addi	a3,a5,8
    8000393e:	068a                	slli	a3,a3,0x2
    80003940:	00235717          	auipc	a4,0x235
    80003944:	fa870713          	addi	a4,a4,-88 # 802388e8 <log>
    80003948:	9736                	add	a4,a4,a3
    8000394a:	44d4                	lw	a3,12(s1)
    8000394c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000394e:	faf609e3          	beq	a2,a5,80003900 <log_write+0x76>
  }
  release(&log.lock);
    80003952:	00235517          	auipc	a0,0x235
    80003956:	f9650513          	addi	a0,a0,-106 # 802388e8 <log>
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	a2e080e7          	jalr	-1490(ra) # 80006388 <release>
}
    80003962:	60e2                	ld	ra,24(sp)
    80003964:	6442                	ld	s0,16(sp)
    80003966:	64a2                	ld	s1,8(sp)
    80003968:	6902                	ld	s2,0(sp)
    8000396a:	6105                	addi	sp,sp,32
    8000396c:	8082                	ret

000000008000396e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000396e:	1101                	addi	sp,sp,-32
    80003970:	ec06                	sd	ra,24(sp)
    80003972:	e822                	sd	s0,16(sp)
    80003974:	e426                	sd	s1,8(sp)
    80003976:	e04a                	sd	s2,0(sp)
    80003978:	1000                	addi	s0,sp,32
    8000397a:	84aa                	mv	s1,a0
    8000397c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000397e:	00005597          	auipc	a1,0x5
    80003982:	c7a58593          	addi	a1,a1,-902 # 800085f8 <syscalls+0x228>
    80003986:	0521                	addi	a0,a0,8
    80003988:	00003097          	auipc	ra,0x3
    8000398c:	8bc080e7          	jalr	-1860(ra) # 80006244 <initlock>
  lk->name = name;
    80003990:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003994:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003998:	0204a423          	sw	zero,40(s1)
}
    8000399c:	60e2                	ld	ra,24(sp)
    8000399e:	6442                	ld	s0,16(sp)
    800039a0:	64a2                	ld	s1,8(sp)
    800039a2:	6902                	ld	s2,0(sp)
    800039a4:	6105                	addi	sp,sp,32
    800039a6:	8082                	ret

00000000800039a8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039a8:	1101                	addi	sp,sp,-32
    800039aa:	ec06                	sd	ra,24(sp)
    800039ac:	e822                	sd	s0,16(sp)
    800039ae:	e426                	sd	s1,8(sp)
    800039b0:	e04a                	sd	s2,0(sp)
    800039b2:	1000                	addi	s0,sp,32
    800039b4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039b6:	00850913          	addi	s2,a0,8
    800039ba:	854a                	mv	a0,s2
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	918080e7          	jalr	-1768(ra) # 800062d4 <acquire>
  while (lk->locked) {
    800039c4:	409c                	lw	a5,0(s1)
    800039c6:	cb89                	beqz	a5,800039d8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039c8:	85ca                	mv	a1,s2
    800039ca:	8526                	mv	a0,s1
    800039cc:	ffffe097          	auipc	ra,0xffffe
    800039d0:	c86080e7          	jalr	-890(ra) # 80001652 <sleep>
  while (lk->locked) {
    800039d4:	409c                	lw	a5,0(s1)
    800039d6:	fbed                	bnez	a5,800039c8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039d8:	4785                	li	a5,1
    800039da:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039dc:	ffffd097          	auipc	ra,0xffffd
    800039e0:	5ce080e7          	jalr	1486(ra) # 80000faa <myproc>
    800039e4:	591c                	lw	a5,48(a0)
    800039e6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039e8:	854a                	mv	a0,s2
    800039ea:	00003097          	auipc	ra,0x3
    800039ee:	99e080e7          	jalr	-1634(ra) # 80006388 <release>
}
    800039f2:	60e2                	ld	ra,24(sp)
    800039f4:	6442                	ld	s0,16(sp)
    800039f6:	64a2                	ld	s1,8(sp)
    800039f8:	6902                	ld	s2,0(sp)
    800039fa:	6105                	addi	sp,sp,32
    800039fc:	8082                	ret

00000000800039fe <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039fe:	1101                	addi	sp,sp,-32
    80003a00:	ec06                	sd	ra,24(sp)
    80003a02:	e822                	sd	s0,16(sp)
    80003a04:	e426                	sd	s1,8(sp)
    80003a06:	e04a                	sd	s2,0(sp)
    80003a08:	1000                	addi	s0,sp,32
    80003a0a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a0c:	00850913          	addi	s2,a0,8
    80003a10:	854a                	mv	a0,s2
    80003a12:	00003097          	auipc	ra,0x3
    80003a16:	8c2080e7          	jalr	-1854(ra) # 800062d4 <acquire>
  lk->locked = 0;
    80003a1a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a1e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a22:	8526                	mv	a0,s1
    80003a24:	ffffe097          	auipc	ra,0xffffe
    80003a28:	c92080e7          	jalr	-878(ra) # 800016b6 <wakeup>
  release(&lk->lk);
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	95a080e7          	jalr	-1702(ra) # 80006388 <release>
}
    80003a36:	60e2                	ld	ra,24(sp)
    80003a38:	6442                	ld	s0,16(sp)
    80003a3a:	64a2                	ld	s1,8(sp)
    80003a3c:	6902                	ld	s2,0(sp)
    80003a3e:	6105                	addi	sp,sp,32
    80003a40:	8082                	ret

0000000080003a42 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a42:	7179                	addi	sp,sp,-48
    80003a44:	f406                	sd	ra,40(sp)
    80003a46:	f022                	sd	s0,32(sp)
    80003a48:	ec26                	sd	s1,24(sp)
    80003a4a:	e84a                	sd	s2,16(sp)
    80003a4c:	e44e                	sd	s3,8(sp)
    80003a4e:	1800                	addi	s0,sp,48
    80003a50:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a52:	00850913          	addi	s2,a0,8
    80003a56:	854a                	mv	a0,s2
    80003a58:	00003097          	auipc	ra,0x3
    80003a5c:	87c080e7          	jalr	-1924(ra) # 800062d4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a60:	409c                	lw	a5,0(s1)
    80003a62:	ef99                	bnez	a5,80003a80 <holdingsleep+0x3e>
    80003a64:	4481                	li	s1,0
  release(&lk->lk);
    80003a66:	854a                	mv	a0,s2
    80003a68:	00003097          	auipc	ra,0x3
    80003a6c:	920080e7          	jalr	-1760(ra) # 80006388 <release>
  return r;
}
    80003a70:	8526                	mv	a0,s1
    80003a72:	70a2                	ld	ra,40(sp)
    80003a74:	7402                	ld	s0,32(sp)
    80003a76:	64e2                	ld	s1,24(sp)
    80003a78:	6942                	ld	s2,16(sp)
    80003a7a:	69a2                	ld	s3,8(sp)
    80003a7c:	6145                	addi	sp,sp,48
    80003a7e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a80:	0284a983          	lw	s3,40(s1)
    80003a84:	ffffd097          	auipc	ra,0xffffd
    80003a88:	526080e7          	jalr	1318(ra) # 80000faa <myproc>
    80003a8c:	5904                	lw	s1,48(a0)
    80003a8e:	413484b3          	sub	s1,s1,s3
    80003a92:	0014b493          	seqz	s1,s1
    80003a96:	bfc1                	j	80003a66 <holdingsleep+0x24>

0000000080003a98 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a98:	1141                	addi	sp,sp,-16
    80003a9a:	e406                	sd	ra,8(sp)
    80003a9c:	e022                	sd	s0,0(sp)
    80003a9e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003aa0:	00005597          	auipc	a1,0x5
    80003aa4:	b6858593          	addi	a1,a1,-1176 # 80008608 <syscalls+0x238>
    80003aa8:	00235517          	auipc	a0,0x235
    80003aac:	f8850513          	addi	a0,a0,-120 # 80238a30 <ftable>
    80003ab0:	00002097          	auipc	ra,0x2
    80003ab4:	794080e7          	jalr	1940(ra) # 80006244 <initlock>
}
    80003ab8:	60a2                	ld	ra,8(sp)
    80003aba:	6402                	ld	s0,0(sp)
    80003abc:	0141                	addi	sp,sp,16
    80003abe:	8082                	ret

0000000080003ac0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ac0:	1101                	addi	sp,sp,-32
    80003ac2:	ec06                	sd	ra,24(sp)
    80003ac4:	e822                	sd	s0,16(sp)
    80003ac6:	e426                	sd	s1,8(sp)
    80003ac8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003aca:	00235517          	auipc	a0,0x235
    80003ace:	f6650513          	addi	a0,a0,-154 # 80238a30 <ftable>
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	802080e7          	jalr	-2046(ra) # 800062d4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ada:	00235497          	auipc	s1,0x235
    80003ade:	f6e48493          	addi	s1,s1,-146 # 80238a48 <ftable+0x18>
    80003ae2:	00236717          	auipc	a4,0x236
    80003ae6:	f0670713          	addi	a4,a4,-250 # 802399e8 <disk>
    if(f->ref == 0){
    80003aea:	40dc                	lw	a5,4(s1)
    80003aec:	cf99                	beqz	a5,80003b0a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aee:	02848493          	addi	s1,s1,40
    80003af2:	fee49ce3          	bne	s1,a4,80003aea <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003af6:	00235517          	auipc	a0,0x235
    80003afa:	f3a50513          	addi	a0,a0,-198 # 80238a30 <ftable>
    80003afe:	00003097          	auipc	ra,0x3
    80003b02:	88a080e7          	jalr	-1910(ra) # 80006388 <release>
  return 0;
    80003b06:	4481                	li	s1,0
    80003b08:	a819                	j	80003b1e <filealloc+0x5e>
      f->ref = 1;
    80003b0a:	4785                	li	a5,1
    80003b0c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b0e:	00235517          	auipc	a0,0x235
    80003b12:	f2250513          	addi	a0,a0,-222 # 80238a30 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	872080e7          	jalr	-1934(ra) # 80006388 <release>
}
    80003b1e:	8526                	mv	a0,s1
    80003b20:	60e2                	ld	ra,24(sp)
    80003b22:	6442                	ld	s0,16(sp)
    80003b24:	64a2                	ld	s1,8(sp)
    80003b26:	6105                	addi	sp,sp,32
    80003b28:	8082                	ret

0000000080003b2a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b2a:	1101                	addi	sp,sp,-32
    80003b2c:	ec06                	sd	ra,24(sp)
    80003b2e:	e822                	sd	s0,16(sp)
    80003b30:	e426                	sd	s1,8(sp)
    80003b32:	1000                	addi	s0,sp,32
    80003b34:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b36:	00235517          	auipc	a0,0x235
    80003b3a:	efa50513          	addi	a0,a0,-262 # 80238a30 <ftable>
    80003b3e:	00002097          	auipc	ra,0x2
    80003b42:	796080e7          	jalr	1942(ra) # 800062d4 <acquire>
  if(f->ref < 1)
    80003b46:	40dc                	lw	a5,4(s1)
    80003b48:	02f05263          	blez	a5,80003b6c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b4c:	2785                	addiw	a5,a5,1
    80003b4e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b50:	00235517          	auipc	a0,0x235
    80003b54:	ee050513          	addi	a0,a0,-288 # 80238a30 <ftable>
    80003b58:	00003097          	auipc	ra,0x3
    80003b5c:	830080e7          	jalr	-2000(ra) # 80006388 <release>
  return f;
}
    80003b60:	8526                	mv	a0,s1
    80003b62:	60e2                	ld	ra,24(sp)
    80003b64:	6442                	ld	s0,16(sp)
    80003b66:	64a2                	ld	s1,8(sp)
    80003b68:	6105                	addi	sp,sp,32
    80003b6a:	8082                	ret
    panic("filedup");
    80003b6c:	00005517          	auipc	a0,0x5
    80003b70:	aa450513          	addi	a0,a0,-1372 # 80008610 <syscalls+0x240>
    80003b74:	00002097          	auipc	ra,0x2
    80003b78:	228080e7          	jalr	552(ra) # 80005d9c <panic>

0000000080003b7c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b7c:	7139                	addi	sp,sp,-64
    80003b7e:	fc06                	sd	ra,56(sp)
    80003b80:	f822                	sd	s0,48(sp)
    80003b82:	f426                	sd	s1,40(sp)
    80003b84:	f04a                	sd	s2,32(sp)
    80003b86:	ec4e                	sd	s3,24(sp)
    80003b88:	e852                	sd	s4,16(sp)
    80003b8a:	e456                	sd	s5,8(sp)
    80003b8c:	0080                	addi	s0,sp,64
    80003b8e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b90:	00235517          	auipc	a0,0x235
    80003b94:	ea050513          	addi	a0,a0,-352 # 80238a30 <ftable>
    80003b98:	00002097          	auipc	ra,0x2
    80003b9c:	73c080e7          	jalr	1852(ra) # 800062d4 <acquire>
  if(f->ref < 1)
    80003ba0:	40dc                	lw	a5,4(s1)
    80003ba2:	06f05163          	blez	a5,80003c04 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ba6:	37fd                	addiw	a5,a5,-1
    80003ba8:	0007871b          	sext.w	a4,a5
    80003bac:	c0dc                	sw	a5,4(s1)
    80003bae:	06e04363          	bgtz	a4,80003c14 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bb2:	0004a903          	lw	s2,0(s1)
    80003bb6:	0094ca83          	lbu	s5,9(s1)
    80003bba:	0104ba03          	ld	s4,16(s1)
    80003bbe:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bc2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bc6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bca:	00235517          	auipc	a0,0x235
    80003bce:	e6650513          	addi	a0,a0,-410 # 80238a30 <ftable>
    80003bd2:	00002097          	auipc	ra,0x2
    80003bd6:	7b6080e7          	jalr	1974(ra) # 80006388 <release>

  if(ff.type == FD_PIPE){
    80003bda:	4785                	li	a5,1
    80003bdc:	04f90d63          	beq	s2,a5,80003c36 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003be0:	3979                	addiw	s2,s2,-2
    80003be2:	4785                	li	a5,1
    80003be4:	0527e063          	bltu	a5,s2,80003c24 <fileclose+0xa8>
    begin_op();
    80003be8:	00000097          	auipc	ra,0x0
    80003bec:	acc080e7          	jalr	-1332(ra) # 800036b4 <begin_op>
    iput(ff.ip);
    80003bf0:	854e                	mv	a0,s3
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	2b0080e7          	jalr	688(ra) # 80002ea2 <iput>
    end_op();
    80003bfa:	00000097          	auipc	ra,0x0
    80003bfe:	b38080e7          	jalr	-1224(ra) # 80003732 <end_op>
    80003c02:	a00d                	j	80003c24 <fileclose+0xa8>
    panic("fileclose");
    80003c04:	00005517          	auipc	a0,0x5
    80003c08:	a1450513          	addi	a0,a0,-1516 # 80008618 <syscalls+0x248>
    80003c0c:	00002097          	auipc	ra,0x2
    80003c10:	190080e7          	jalr	400(ra) # 80005d9c <panic>
    release(&ftable.lock);
    80003c14:	00235517          	auipc	a0,0x235
    80003c18:	e1c50513          	addi	a0,a0,-484 # 80238a30 <ftable>
    80003c1c:	00002097          	auipc	ra,0x2
    80003c20:	76c080e7          	jalr	1900(ra) # 80006388 <release>
  }
}
    80003c24:	70e2                	ld	ra,56(sp)
    80003c26:	7442                	ld	s0,48(sp)
    80003c28:	74a2                	ld	s1,40(sp)
    80003c2a:	7902                	ld	s2,32(sp)
    80003c2c:	69e2                	ld	s3,24(sp)
    80003c2e:	6a42                	ld	s4,16(sp)
    80003c30:	6aa2                	ld	s5,8(sp)
    80003c32:	6121                	addi	sp,sp,64
    80003c34:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c36:	85d6                	mv	a1,s5
    80003c38:	8552                	mv	a0,s4
    80003c3a:	00000097          	auipc	ra,0x0
    80003c3e:	34c080e7          	jalr	844(ra) # 80003f86 <pipeclose>
    80003c42:	b7cd                	j	80003c24 <fileclose+0xa8>

0000000080003c44 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c44:	715d                	addi	sp,sp,-80
    80003c46:	e486                	sd	ra,72(sp)
    80003c48:	e0a2                	sd	s0,64(sp)
    80003c4a:	fc26                	sd	s1,56(sp)
    80003c4c:	f84a                	sd	s2,48(sp)
    80003c4e:	f44e                	sd	s3,40(sp)
    80003c50:	0880                	addi	s0,sp,80
    80003c52:	84aa                	mv	s1,a0
    80003c54:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c56:	ffffd097          	auipc	ra,0xffffd
    80003c5a:	354080e7          	jalr	852(ra) # 80000faa <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c5e:	409c                	lw	a5,0(s1)
    80003c60:	37f9                	addiw	a5,a5,-2
    80003c62:	4705                	li	a4,1
    80003c64:	04f76763          	bltu	a4,a5,80003cb2 <filestat+0x6e>
    80003c68:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c6a:	6c88                	ld	a0,24(s1)
    80003c6c:	fffff097          	auipc	ra,0xfffff
    80003c70:	07c080e7          	jalr	124(ra) # 80002ce8 <ilock>
    stati(f->ip, &st);
    80003c74:	fb840593          	addi	a1,s0,-72
    80003c78:	6c88                	ld	a0,24(s1)
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	2f8080e7          	jalr	760(ra) # 80002f72 <stati>
    iunlock(f->ip);
    80003c82:	6c88                	ld	a0,24(s1)
    80003c84:	fffff097          	auipc	ra,0xfffff
    80003c88:	126080e7          	jalr	294(ra) # 80002daa <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c8c:	46e1                	li	a3,24
    80003c8e:	fb840613          	addi	a2,s0,-72
    80003c92:	85ce                	mv	a1,s3
    80003c94:	05093503          	ld	a0,80(s2)
    80003c98:	ffffd097          	auipc	ra,0xffffd
    80003c9c:	f44080e7          	jalr	-188(ra) # 80000bdc <copyout>
    80003ca0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ca4:	60a6                	ld	ra,72(sp)
    80003ca6:	6406                	ld	s0,64(sp)
    80003ca8:	74e2                	ld	s1,56(sp)
    80003caa:	7942                	ld	s2,48(sp)
    80003cac:	79a2                	ld	s3,40(sp)
    80003cae:	6161                	addi	sp,sp,80
    80003cb0:	8082                	ret
  return -1;
    80003cb2:	557d                	li	a0,-1
    80003cb4:	bfc5                	j	80003ca4 <filestat+0x60>

0000000080003cb6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cb6:	7179                	addi	sp,sp,-48
    80003cb8:	f406                	sd	ra,40(sp)
    80003cba:	f022                	sd	s0,32(sp)
    80003cbc:	ec26                	sd	s1,24(sp)
    80003cbe:	e84a                	sd	s2,16(sp)
    80003cc0:	e44e                	sd	s3,8(sp)
    80003cc2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cc4:	00854783          	lbu	a5,8(a0)
    80003cc8:	c3d5                	beqz	a5,80003d6c <fileread+0xb6>
    80003cca:	84aa                	mv	s1,a0
    80003ccc:	89ae                	mv	s3,a1
    80003cce:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cd0:	411c                	lw	a5,0(a0)
    80003cd2:	4705                	li	a4,1
    80003cd4:	04e78963          	beq	a5,a4,80003d26 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cd8:	470d                	li	a4,3
    80003cda:	04e78d63          	beq	a5,a4,80003d34 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cde:	4709                	li	a4,2
    80003ce0:	06e79e63          	bne	a5,a4,80003d5c <fileread+0xa6>
    ilock(f->ip);
    80003ce4:	6d08                	ld	a0,24(a0)
    80003ce6:	fffff097          	auipc	ra,0xfffff
    80003cea:	002080e7          	jalr	2(ra) # 80002ce8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cee:	874a                	mv	a4,s2
    80003cf0:	5094                	lw	a3,32(s1)
    80003cf2:	864e                	mv	a2,s3
    80003cf4:	4585                	li	a1,1
    80003cf6:	6c88                	ld	a0,24(s1)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	2a4080e7          	jalr	676(ra) # 80002f9c <readi>
    80003d00:	892a                	mv	s2,a0
    80003d02:	00a05563          	blez	a0,80003d0c <fileread+0x56>
      f->off += r;
    80003d06:	509c                	lw	a5,32(s1)
    80003d08:	9fa9                	addw	a5,a5,a0
    80003d0a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d0c:	6c88                	ld	a0,24(s1)
    80003d0e:	fffff097          	auipc	ra,0xfffff
    80003d12:	09c080e7          	jalr	156(ra) # 80002daa <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d16:	854a                	mv	a0,s2
    80003d18:	70a2                	ld	ra,40(sp)
    80003d1a:	7402                	ld	s0,32(sp)
    80003d1c:	64e2                	ld	s1,24(sp)
    80003d1e:	6942                	ld	s2,16(sp)
    80003d20:	69a2                	ld	s3,8(sp)
    80003d22:	6145                	addi	sp,sp,48
    80003d24:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d26:	6908                	ld	a0,16(a0)
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	3c6080e7          	jalr	966(ra) # 800040ee <piperead>
    80003d30:	892a                	mv	s2,a0
    80003d32:	b7d5                	j	80003d16 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d34:	02451783          	lh	a5,36(a0)
    80003d38:	03079693          	slli	a3,a5,0x30
    80003d3c:	92c1                	srli	a3,a3,0x30
    80003d3e:	4725                	li	a4,9
    80003d40:	02d76863          	bltu	a4,a3,80003d70 <fileread+0xba>
    80003d44:	0792                	slli	a5,a5,0x4
    80003d46:	00235717          	auipc	a4,0x235
    80003d4a:	c4a70713          	addi	a4,a4,-950 # 80238990 <devsw>
    80003d4e:	97ba                	add	a5,a5,a4
    80003d50:	639c                	ld	a5,0(a5)
    80003d52:	c38d                	beqz	a5,80003d74 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d54:	4505                	li	a0,1
    80003d56:	9782                	jalr	a5
    80003d58:	892a                	mv	s2,a0
    80003d5a:	bf75                	j	80003d16 <fileread+0x60>
    panic("fileread");
    80003d5c:	00005517          	auipc	a0,0x5
    80003d60:	8cc50513          	addi	a0,a0,-1844 # 80008628 <syscalls+0x258>
    80003d64:	00002097          	auipc	ra,0x2
    80003d68:	038080e7          	jalr	56(ra) # 80005d9c <panic>
    return -1;
    80003d6c:	597d                	li	s2,-1
    80003d6e:	b765                	j	80003d16 <fileread+0x60>
      return -1;
    80003d70:	597d                	li	s2,-1
    80003d72:	b755                	j	80003d16 <fileread+0x60>
    80003d74:	597d                	li	s2,-1
    80003d76:	b745                	j	80003d16 <fileread+0x60>

0000000080003d78 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d78:	715d                	addi	sp,sp,-80
    80003d7a:	e486                	sd	ra,72(sp)
    80003d7c:	e0a2                	sd	s0,64(sp)
    80003d7e:	fc26                	sd	s1,56(sp)
    80003d80:	f84a                	sd	s2,48(sp)
    80003d82:	f44e                	sd	s3,40(sp)
    80003d84:	f052                	sd	s4,32(sp)
    80003d86:	ec56                	sd	s5,24(sp)
    80003d88:	e85a                	sd	s6,16(sp)
    80003d8a:	e45e                	sd	s7,8(sp)
    80003d8c:	e062                	sd	s8,0(sp)
    80003d8e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d90:	00954783          	lbu	a5,9(a0)
    80003d94:	10078663          	beqz	a5,80003ea0 <filewrite+0x128>
    80003d98:	892a                	mv	s2,a0
    80003d9a:	8b2e                	mv	s6,a1
    80003d9c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d9e:	411c                	lw	a5,0(a0)
    80003da0:	4705                	li	a4,1
    80003da2:	02e78263          	beq	a5,a4,80003dc6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003da6:	470d                	li	a4,3
    80003da8:	02e78663          	beq	a5,a4,80003dd4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dac:	4709                	li	a4,2
    80003dae:	0ee79163          	bne	a5,a4,80003e90 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003db2:	0ac05d63          	blez	a2,80003e6c <filewrite+0xf4>
    int i = 0;
    80003db6:	4981                	li	s3,0
    80003db8:	6b85                	lui	s7,0x1
    80003dba:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003dbe:	6c05                	lui	s8,0x1
    80003dc0:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003dc4:	a861                	j	80003e5c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dc6:	6908                	ld	a0,16(a0)
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	22e080e7          	jalr	558(ra) # 80003ff6 <pipewrite>
    80003dd0:	8a2a                	mv	s4,a0
    80003dd2:	a045                	j	80003e72 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dd4:	02451783          	lh	a5,36(a0)
    80003dd8:	03079693          	slli	a3,a5,0x30
    80003ddc:	92c1                	srli	a3,a3,0x30
    80003dde:	4725                	li	a4,9
    80003de0:	0cd76263          	bltu	a4,a3,80003ea4 <filewrite+0x12c>
    80003de4:	0792                	slli	a5,a5,0x4
    80003de6:	00235717          	auipc	a4,0x235
    80003dea:	baa70713          	addi	a4,a4,-1110 # 80238990 <devsw>
    80003dee:	97ba                	add	a5,a5,a4
    80003df0:	679c                	ld	a5,8(a5)
    80003df2:	cbdd                	beqz	a5,80003ea8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003df4:	4505                	li	a0,1
    80003df6:	9782                	jalr	a5
    80003df8:	8a2a                	mv	s4,a0
    80003dfa:	a8a5                	j	80003e72 <filewrite+0xfa>
    80003dfc:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e00:	00000097          	auipc	ra,0x0
    80003e04:	8b4080e7          	jalr	-1868(ra) # 800036b4 <begin_op>
      ilock(f->ip);
    80003e08:	01893503          	ld	a0,24(s2)
    80003e0c:	fffff097          	auipc	ra,0xfffff
    80003e10:	edc080e7          	jalr	-292(ra) # 80002ce8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e14:	8756                	mv	a4,s5
    80003e16:	02092683          	lw	a3,32(s2)
    80003e1a:	01698633          	add	a2,s3,s6
    80003e1e:	4585                	li	a1,1
    80003e20:	01893503          	ld	a0,24(s2)
    80003e24:	fffff097          	auipc	ra,0xfffff
    80003e28:	270080e7          	jalr	624(ra) # 80003094 <writei>
    80003e2c:	84aa                	mv	s1,a0
    80003e2e:	00a05763          	blez	a0,80003e3c <filewrite+0xc4>
        f->off += r;
    80003e32:	02092783          	lw	a5,32(s2)
    80003e36:	9fa9                	addw	a5,a5,a0
    80003e38:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e3c:	01893503          	ld	a0,24(s2)
    80003e40:	fffff097          	auipc	ra,0xfffff
    80003e44:	f6a080e7          	jalr	-150(ra) # 80002daa <iunlock>
      end_op();
    80003e48:	00000097          	auipc	ra,0x0
    80003e4c:	8ea080e7          	jalr	-1814(ra) # 80003732 <end_op>

      if(r != n1){
    80003e50:	009a9f63          	bne	s5,s1,80003e6e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e54:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e58:	0149db63          	bge	s3,s4,80003e6e <filewrite+0xf6>
      int n1 = n - i;
    80003e5c:	413a04bb          	subw	s1,s4,s3
    80003e60:	0004879b          	sext.w	a5,s1
    80003e64:	f8fbdce3          	bge	s7,a5,80003dfc <filewrite+0x84>
    80003e68:	84e2                	mv	s1,s8
    80003e6a:	bf49                	j	80003dfc <filewrite+0x84>
    int i = 0;
    80003e6c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e6e:	013a1f63          	bne	s4,s3,80003e8c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e72:	8552                	mv	a0,s4
    80003e74:	60a6                	ld	ra,72(sp)
    80003e76:	6406                	ld	s0,64(sp)
    80003e78:	74e2                	ld	s1,56(sp)
    80003e7a:	7942                	ld	s2,48(sp)
    80003e7c:	79a2                	ld	s3,40(sp)
    80003e7e:	7a02                	ld	s4,32(sp)
    80003e80:	6ae2                	ld	s5,24(sp)
    80003e82:	6b42                	ld	s6,16(sp)
    80003e84:	6ba2                	ld	s7,8(sp)
    80003e86:	6c02                	ld	s8,0(sp)
    80003e88:	6161                	addi	sp,sp,80
    80003e8a:	8082                	ret
    ret = (i == n ? n : -1);
    80003e8c:	5a7d                	li	s4,-1
    80003e8e:	b7d5                	j	80003e72 <filewrite+0xfa>
    panic("filewrite");
    80003e90:	00004517          	auipc	a0,0x4
    80003e94:	7a850513          	addi	a0,a0,1960 # 80008638 <syscalls+0x268>
    80003e98:	00002097          	auipc	ra,0x2
    80003e9c:	f04080e7          	jalr	-252(ra) # 80005d9c <panic>
    return -1;
    80003ea0:	5a7d                	li	s4,-1
    80003ea2:	bfc1                	j	80003e72 <filewrite+0xfa>
      return -1;
    80003ea4:	5a7d                	li	s4,-1
    80003ea6:	b7f1                	j	80003e72 <filewrite+0xfa>
    80003ea8:	5a7d                	li	s4,-1
    80003eaa:	b7e1                	j	80003e72 <filewrite+0xfa>

0000000080003eac <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003eac:	7179                	addi	sp,sp,-48
    80003eae:	f406                	sd	ra,40(sp)
    80003eb0:	f022                	sd	s0,32(sp)
    80003eb2:	ec26                	sd	s1,24(sp)
    80003eb4:	e84a                	sd	s2,16(sp)
    80003eb6:	e44e                	sd	s3,8(sp)
    80003eb8:	e052                	sd	s4,0(sp)
    80003eba:	1800                	addi	s0,sp,48
    80003ebc:	84aa                	mv	s1,a0
    80003ebe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ec0:	0005b023          	sd	zero,0(a1)
    80003ec4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	bf8080e7          	jalr	-1032(ra) # 80003ac0 <filealloc>
    80003ed0:	e088                	sd	a0,0(s1)
    80003ed2:	c551                	beqz	a0,80003f5e <pipealloc+0xb2>
    80003ed4:	00000097          	auipc	ra,0x0
    80003ed8:	bec080e7          	jalr	-1044(ra) # 80003ac0 <filealloc>
    80003edc:	00aa3023          	sd	a0,0(s4)
    80003ee0:	c92d                	beqz	a0,80003f52 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ee2:	ffffc097          	auipc	ra,0xffffc
    80003ee6:	27c080e7          	jalr	636(ra) # 8000015e <kalloc>
    80003eea:	892a                	mv	s2,a0
    80003eec:	c125                	beqz	a0,80003f4c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003eee:	4985                	li	s3,1
    80003ef0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ef4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ef8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003efc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f00:	00004597          	auipc	a1,0x4
    80003f04:	74858593          	addi	a1,a1,1864 # 80008648 <syscalls+0x278>
    80003f08:	00002097          	auipc	ra,0x2
    80003f0c:	33c080e7          	jalr	828(ra) # 80006244 <initlock>
  (*f0)->type = FD_PIPE;
    80003f10:	609c                	ld	a5,0(s1)
    80003f12:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f16:	609c                	ld	a5,0(s1)
    80003f18:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f1c:	609c                	ld	a5,0(s1)
    80003f1e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f22:	609c                	ld	a5,0(s1)
    80003f24:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f28:	000a3783          	ld	a5,0(s4)
    80003f2c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f30:	000a3783          	ld	a5,0(s4)
    80003f34:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f38:	000a3783          	ld	a5,0(s4)
    80003f3c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f40:	000a3783          	ld	a5,0(s4)
    80003f44:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f48:	4501                	li	a0,0
    80003f4a:	a025                	j	80003f72 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f4c:	6088                	ld	a0,0(s1)
    80003f4e:	e501                	bnez	a0,80003f56 <pipealloc+0xaa>
    80003f50:	a039                	j	80003f5e <pipealloc+0xb2>
    80003f52:	6088                	ld	a0,0(s1)
    80003f54:	c51d                	beqz	a0,80003f82 <pipealloc+0xd6>
    fileclose(*f0);
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	c26080e7          	jalr	-986(ra) # 80003b7c <fileclose>
  if(*f1)
    80003f5e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f62:	557d                	li	a0,-1
  if(*f1)
    80003f64:	c799                	beqz	a5,80003f72 <pipealloc+0xc6>
    fileclose(*f1);
    80003f66:	853e                	mv	a0,a5
    80003f68:	00000097          	auipc	ra,0x0
    80003f6c:	c14080e7          	jalr	-1004(ra) # 80003b7c <fileclose>
  return -1;
    80003f70:	557d                	li	a0,-1
}
    80003f72:	70a2                	ld	ra,40(sp)
    80003f74:	7402                	ld	s0,32(sp)
    80003f76:	64e2                	ld	s1,24(sp)
    80003f78:	6942                	ld	s2,16(sp)
    80003f7a:	69a2                	ld	s3,8(sp)
    80003f7c:	6a02                	ld	s4,0(sp)
    80003f7e:	6145                	addi	sp,sp,48
    80003f80:	8082                	ret
  return -1;
    80003f82:	557d                	li	a0,-1
    80003f84:	b7fd                	j	80003f72 <pipealloc+0xc6>

0000000080003f86 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f86:	1101                	addi	sp,sp,-32
    80003f88:	ec06                	sd	ra,24(sp)
    80003f8a:	e822                	sd	s0,16(sp)
    80003f8c:	e426                	sd	s1,8(sp)
    80003f8e:	e04a                	sd	s2,0(sp)
    80003f90:	1000                	addi	s0,sp,32
    80003f92:	84aa                	mv	s1,a0
    80003f94:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f96:	00002097          	auipc	ra,0x2
    80003f9a:	33e080e7          	jalr	830(ra) # 800062d4 <acquire>
  if(writable){
    80003f9e:	02090d63          	beqz	s2,80003fd8 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fa2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fa6:	21848513          	addi	a0,s1,536
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	70c080e7          	jalr	1804(ra) # 800016b6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fb2:	2204b783          	ld	a5,544(s1)
    80003fb6:	eb95                	bnez	a5,80003fea <pipeclose+0x64>
    release(&pi->lock);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	00002097          	auipc	ra,0x2
    80003fbe:	3ce080e7          	jalr	974(ra) # 80006388 <release>
    kfree((char*)pi);
    80003fc2:	8526                	mv	a0,s1
    80003fc4:	ffffc097          	auipc	ra,0xffffc
    80003fc8:	058080e7          	jalr	88(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fcc:	60e2                	ld	ra,24(sp)
    80003fce:	6442                	ld	s0,16(sp)
    80003fd0:	64a2                	ld	s1,8(sp)
    80003fd2:	6902                	ld	s2,0(sp)
    80003fd4:	6105                	addi	sp,sp,32
    80003fd6:	8082                	ret
    pi->readopen = 0;
    80003fd8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fdc:	21c48513          	addi	a0,s1,540
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	6d6080e7          	jalr	1750(ra) # 800016b6 <wakeup>
    80003fe8:	b7e9                	j	80003fb2 <pipeclose+0x2c>
    release(&pi->lock);
    80003fea:	8526                	mv	a0,s1
    80003fec:	00002097          	auipc	ra,0x2
    80003ff0:	39c080e7          	jalr	924(ra) # 80006388 <release>
}
    80003ff4:	bfe1                	j	80003fcc <pipeclose+0x46>

0000000080003ff6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ff6:	711d                	addi	sp,sp,-96
    80003ff8:	ec86                	sd	ra,88(sp)
    80003ffa:	e8a2                	sd	s0,80(sp)
    80003ffc:	e4a6                	sd	s1,72(sp)
    80003ffe:	e0ca                	sd	s2,64(sp)
    80004000:	fc4e                	sd	s3,56(sp)
    80004002:	f852                	sd	s4,48(sp)
    80004004:	f456                	sd	s5,40(sp)
    80004006:	f05a                	sd	s6,32(sp)
    80004008:	ec5e                	sd	s7,24(sp)
    8000400a:	e862                	sd	s8,16(sp)
    8000400c:	1080                	addi	s0,sp,96
    8000400e:	84aa                	mv	s1,a0
    80004010:	8aae                	mv	s5,a1
    80004012:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	f96080e7          	jalr	-106(ra) # 80000faa <myproc>
    8000401c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000401e:	8526                	mv	a0,s1
    80004020:	00002097          	auipc	ra,0x2
    80004024:	2b4080e7          	jalr	692(ra) # 800062d4 <acquire>
  while(i < n){
    80004028:	0b405663          	blez	s4,800040d4 <pipewrite+0xde>
  int i = 0;
    8000402c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000402e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004030:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004034:	21c48b93          	addi	s7,s1,540
    80004038:	a089                	j	8000407a <pipewrite+0x84>
      release(&pi->lock);
    8000403a:	8526                	mv	a0,s1
    8000403c:	00002097          	auipc	ra,0x2
    80004040:	34c080e7          	jalr	844(ra) # 80006388 <release>
      return -1;
    80004044:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004046:	854a                	mv	a0,s2
    80004048:	60e6                	ld	ra,88(sp)
    8000404a:	6446                	ld	s0,80(sp)
    8000404c:	64a6                	ld	s1,72(sp)
    8000404e:	6906                	ld	s2,64(sp)
    80004050:	79e2                	ld	s3,56(sp)
    80004052:	7a42                	ld	s4,48(sp)
    80004054:	7aa2                	ld	s5,40(sp)
    80004056:	7b02                	ld	s6,32(sp)
    80004058:	6be2                	ld	s7,24(sp)
    8000405a:	6c42                	ld	s8,16(sp)
    8000405c:	6125                	addi	sp,sp,96
    8000405e:	8082                	ret
      wakeup(&pi->nread);
    80004060:	8562                	mv	a0,s8
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	654080e7          	jalr	1620(ra) # 800016b6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000406a:	85a6                	mv	a1,s1
    8000406c:	855e                	mv	a0,s7
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	5e4080e7          	jalr	1508(ra) # 80001652 <sleep>
  while(i < n){
    80004076:	07495063          	bge	s2,s4,800040d6 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000407a:	2204a783          	lw	a5,544(s1)
    8000407e:	dfd5                	beqz	a5,8000403a <pipewrite+0x44>
    80004080:	854e                	mv	a0,s3
    80004082:	ffffe097          	auipc	ra,0xffffe
    80004086:	878080e7          	jalr	-1928(ra) # 800018fa <killed>
    8000408a:	f945                	bnez	a0,8000403a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000408c:	2184a783          	lw	a5,536(s1)
    80004090:	21c4a703          	lw	a4,540(s1)
    80004094:	2007879b          	addiw	a5,a5,512
    80004098:	fcf704e3          	beq	a4,a5,80004060 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000409c:	4685                	li	a3,1
    8000409e:	01590633          	add	a2,s2,s5
    800040a2:	faf40593          	addi	a1,s0,-81
    800040a6:	0509b503          	ld	a0,80(s3)
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	c50080e7          	jalr	-944(ra) # 80000cfa <copyin>
    800040b2:	03650263          	beq	a0,s6,800040d6 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040b6:	21c4a783          	lw	a5,540(s1)
    800040ba:	0017871b          	addiw	a4,a5,1
    800040be:	20e4ae23          	sw	a4,540(s1)
    800040c2:	1ff7f793          	andi	a5,a5,511
    800040c6:	97a6                	add	a5,a5,s1
    800040c8:	faf44703          	lbu	a4,-81(s0)
    800040cc:	00e78c23          	sb	a4,24(a5)
      i++;
    800040d0:	2905                	addiw	s2,s2,1
    800040d2:	b755                	j	80004076 <pipewrite+0x80>
  int i = 0;
    800040d4:	4901                	li	s2,0
  wakeup(&pi->nread);
    800040d6:	21848513          	addi	a0,s1,536
    800040da:	ffffd097          	auipc	ra,0xffffd
    800040de:	5dc080e7          	jalr	1500(ra) # 800016b6 <wakeup>
  release(&pi->lock);
    800040e2:	8526                	mv	a0,s1
    800040e4:	00002097          	auipc	ra,0x2
    800040e8:	2a4080e7          	jalr	676(ra) # 80006388 <release>
  return i;
    800040ec:	bfa9                	j	80004046 <pipewrite+0x50>

00000000800040ee <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040ee:	715d                	addi	sp,sp,-80
    800040f0:	e486                	sd	ra,72(sp)
    800040f2:	e0a2                	sd	s0,64(sp)
    800040f4:	fc26                	sd	s1,56(sp)
    800040f6:	f84a                	sd	s2,48(sp)
    800040f8:	f44e                	sd	s3,40(sp)
    800040fa:	f052                	sd	s4,32(sp)
    800040fc:	ec56                	sd	s5,24(sp)
    800040fe:	e85a                	sd	s6,16(sp)
    80004100:	0880                	addi	s0,sp,80
    80004102:	84aa                	mv	s1,a0
    80004104:	892e                	mv	s2,a1
    80004106:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	ea2080e7          	jalr	-350(ra) # 80000faa <myproc>
    80004110:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004112:	8526                	mv	a0,s1
    80004114:	00002097          	auipc	ra,0x2
    80004118:	1c0080e7          	jalr	448(ra) # 800062d4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000411c:	2184a703          	lw	a4,536(s1)
    80004120:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004124:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004128:	02f71763          	bne	a4,a5,80004156 <piperead+0x68>
    8000412c:	2244a783          	lw	a5,548(s1)
    80004130:	c39d                	beqz	a5,80004156 <piperead+0x68>
    if(killed(pr)){
    80004132:	8552                	mv	a0,s4
    80004134:	ffffd097          	auipc	ra,0xffffd
    80004138:	7c6080e7          	jalr	1990(ra) # 800018fa <killed>
    8000413c:	e949                	bnez	a0,800041ce <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000413e:	85a6                	mv	a1,s1
    80004140:	854e                	mv	a0,s3
    80004142:	ffffd097          	auipc	ra,0xffffd
    80004146:	510080e7          	jalr	1296(ra) # 80001652 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000414a:	2184a703          	lw	a4,536(s1)
    8000414e:	21c4a783          	lw	a5,540(s1)
    80004152:	fcf70de3          	beq	a4,a5,8000412c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004156:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004158:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000415a:	05505463          	blez	s5,800041a2 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000415e:	2184a783          	lw	a5,536(s1)
    80004162:	21c4a703          	lw	a4,540(s1)
    80004166:	02f70e63          	beq	a4,a5,800041a2 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000416a:	0017871b          	addiw	a4,a5,1
    8000416e:	20e4ac23          	sw	a4,536(s1)
    80004172:	1ff7f793          	andi	a5,a5,511
    80004176:	97a6                	add	a5,a5,s1
    80004178:	0187c783          	lbu	a5,24(a5)
    8000417c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004180:	4685                	li	a3,1
    80004182:	fbf40613          	addi	a2,s0,-65
    80004186:	85ca                	mv	a1,s2
    80004188:	050a3503          	ld	a0,80(s4)
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	a50080e7          	jalr	-1456(ra) # 80000bdc <copyout>
    80004194:	01650763          	beq	a0,s6,800041a2 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004198:	2985                	addiw	s3,s3,1
    8000419a:	0905                	addi	s2,s2,1
    8000419c:	fd3a91e3          	bne	s5,s3,8000415e <piperead+0x70>
    800041a0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041a2:	21c48513          	addi	a0,s1,540
    800041a6:	ffffd097          	auipc	ra,0xffffd
    800041aa:	510080e7          	jalr	1296(ra) # 800016b6 <wakeup>
  release(&pi->lock);
    800041ae:	8526                	mv	a0,s1
    800041b0:	00002097          	auipc	ra,0x2
    800041b4:	1d8080e7          	jalr	472(ra) # 80006388 <release>
  return i;
}
    800041b8:	854e                	mv	a0,s3
    800041ba:	60a6                	ld	ra,72(sp)
    800041bc:	6406                	ld	s0,64(sp)
    800041be:	74e2                	ld	s1,56(sp)
    800041c0:	7942                	ld	s2,48(sp)
    800041c2:	79a2                	ld	s3,40(sp)
    800041c4:	7a02                	ld	s4,32(sp)
    800041c6:	6ae2                	ld	s5,24(sp)
    800041c8:	6b42                	ld	s6,16(sp)
    800041ca:	6161                	addi	sp,sp,80
    800041cc:	8082                	ret
      release(&pi->lock);
    800041ce:	8526                	mv	a0,s1
    800041d0:	00002097          	auipc	ra,0x2
    800041d4:	1b8080e7          	jalr	440(ra) # 80006388 <release>
      return -1;
    800041d8:	59fd                	li	s3,-1
    800041da:	bff9                	j	800041b8 <piperead+0xca>

00000000800041dc <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800041dc:	1141                	addi	sp,sp,-16
    800041de:	e422                	sd	s0,8(sp)
    800041e0:	0800                	addi	s0,sp,16
    800041e2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041e4:	8905                	andi	a0,a0,1
    800041e6:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800041e8:	8b89                	andi	a5,a5,2
    800041ea:	c399                	beqz	a5,800041f0 <flags2perm+0x14>
      perm |= PTE_W;
    800041ec:	00456513          	ori	a0,a0,4
    return perm;
}
    800041f0:	6422                	ld	s0,8(sp)
    800041f2:	0141                	addi	sp,sp,16
    800041f4:	8082                	ret

00000000800041f6 <exec>:

int
exec(char *path, char **argv)
{
    800041f6:	de010113          	addi	sp,sp,-544
    800041fa:	20113c23          	sd	ra,536(sp)
    800041fe:	20813823          	sd	s0,528(sp)
    80004202:	20913423          	sd	s1,520(sp)
    80004206:	21213023          	sd	s2,512(sp)
    8000420a:	ffce                	sd	s3,504(sp)
    8000420c:	fbd2                	sd	s4,496(sp)
    8000420e:	f7d6                	sd	s5,488(sp)
    80004210:	f3da                	sd	s6,480(sp)
    80004212:	efde                	sd	s7,472(sp)
    80004214:	ebe2                	sd	s8,464(sp)
    80004216:	e7e6                	sd	s9,456(sp)
    80004218:	e3ea                	sd	s10,448(sp)
    8000421a:	ff6e                	sd	s11,440(sp)
    8000421c:	1400                	addi	s0,sp,544
    8000421e:	892a                	mv	s2,a0
    80004220:	dea43423          	sd	a0,-536(s0)
    80004224:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004228:	ffffd097          	auipc	ra,0xffffd
    8000422c:	d82080e7          	jalr	-638(ra) # 80000faa <myproc>
    80004230:	84aa                	mv	s1,a0

  begin_op();
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	482080e7          	jalr	1154(ra) # 800036b4 <begin_op>

  if((ip = namei(path)) == 0){
    8000423a:	854a                	mv	a0,s2
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	258080e7          	jalr	600(ra) # 80003494 <namei>
    80004244:	c93d                	beqz	a0,800042ba <exec+0xc4>
    80004246:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004248:	fffff097          	auipc	ra,0xfffff
    8000424c:	aa0080e7          	jalr	-1376(ra) # 80002ce8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004250:	04000713          	li	a4,64
    80004254:	4681                	li	a3,0
    80004256:	e5040613          	addi	a2,s0,-432
    8000425a:	4581                	li	a1,0
    8000425c:	8556                	mv	a0,s5
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	d3e080e7          	jalr	-706(ra) # 80002f9c <readi>
    80004266:	04000793          	li	a5,64
    8000426a:	00f51a63          	bne	a0,a5,8000427e <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000426e:	e5042703          	lw	a4,-432(s0)
    80004272:	464c47b7          	lui	a5,0x464c4
    80004276:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000427a:	04f70663          	beq	a4,a5,800042c6 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000427e:	8556                	mv	a0,s5
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	cca080e7          	jalr	-822(ra) # 80002f4a <iunlockput>
    end_op();
    80004288:	fffff097          	auipc	ra,0xfffff
    8000428c:	4aa080e7          	jalr	1194(ra) # 80003732 <end_op>
  }
  return -1;
    80004290:	557d                	li	a0,-1
}
    80004292:	21813083          	ld	ra,536(sp)
    80004296:	21013403          	ld	s0,528(sp)
    8000429a:	20813483          	ld	s1,520(sp)
    8000429e:	20013903          	ld	s2,512(sp)
    800042a2:	79fe                	ld	s3,504(sp)
    800042a4:	7a5e                	ld	s4,496(sp)
    800042a6:	7abe                	ld	s5,488(sp)
    800042a8:	7b1e                	ld	s6,480(sp)
    800042aa:	6bfe                	ld	s7,472(sp)
    800042ac:	6c5e                	ld	s8,464(sp)
    800042ae:	6cbe                	ld	s9,456(sp)
    800042b0:	6d1e                	ld	s10,448(sp)
    800042b2:	7dfa                	ld	s11,440(sp)
    800042b4:	22010113          	addi	sp,sp,544
    800042b8:	8082                	ret
    end_op();
    800042ba:	fffff097          	auipc	ra,0xfffff
    800042be:	478080e7          	jalr	1144(ra) # 80003732 <end_op>
    return -1;
    800042c2:	557d                	li	a0,-1
    800042c4:	b7f9                	j	80004292 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800042c6:	8526                	mv	a0,s1
    800042c8:	ffffd097          	auipc	ra,0xffffd
    800042cc:	da6080e7          	jalr	-602(ra) # 8000106e <proc_pagetable>
    800042d0:	8b2a                	mv	s6,a0
    800042d2:	d555                	beqz	a0,8000427e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042d4:	e7042783          	lw	a5,-400(s0)
    800042d8:	e8845703          	lhu	a4,-376(s0)
    800042dc:	c735                	beqz	a4,80004348 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042de:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e0:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800042e4:	6a05                	lui	s4,0x1
    800042e6:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800042ea:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800042ee:	6d85                	lui	s11,0x1
    800042f0:	7d7d                	lui	s10,0xfffff
    800042f2:	ac3d                	j	80004530 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042f4:	00004517          	auipc	a0,0x4
    800042f8:	35c50513          	addi	a0,a0,860 # 80008650 <syscalls+0x280>
    800042fc:	00002097          	auipc	ra,0x2
    80004300:	aa0080e7          	jalr	-1376(ra) # 80005d9c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004304:	874a                	mv	a4,s2
    80004306:	009c86bb          	addw	a3,s9,s1
    8000430a:	4581                	li	a1,0
    8000430c:	8556                	mv	a0,s5
    8000430e:	fffff097          	auipc	ra,0xfffff
    80004312:	c8e080e7          	jalr	-882(ra) # 80002f9c <readi>
    80004316:	2501                	sext.w	a0,a0
    80004318:	1aa91963          	bne	s2,a0,800044ca <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    8000431c:	009d84bb          	addw	s1,s11,s1
    80004320:	013d09bb          	addw	s3,s10,s3
    80004324:	1f74f663          	bgeu	s1,s7,80004510 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    80004328:	02049593          	slli	a1,s1,0x20
    8000432c:	9181                	srli	a1,a1,0x20
    8000432e:	95e2                	add	a1,a1,s8
    80004330:	855a                	mv	a0,s6
    80004332:	ffffc097          	auipc	ra,0xffffc
    80004336:	250080e7          	jalr	592(ra) # 80000582 <walkaddr>
    8000433a:	862a                	mv	a2,a0
    if(pa == 0)
    8000433c:	dd45                	beqz	a0,800042f4 <exec+0xfe>
      n = PGSIZE;
    8000433e:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004340:	fd49f2e3          	bgeu	s3,s4,80004304 <exec+0x10e>
      n = sz - i;
    80004344:	894e                	mv	s2,s3
    80004346:	bf7d                	j	80004304 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004348:	4901                	li	s2,0
  iunlockput(ip);
    8000434a:	8556                	mv	a0,s5
    8000434c:	fffff097          	auipc	ra,0xfffff
    80004350:	bfe080e7          	jalr	-1026(ra) # 80002f4a <iunlockput>
  end_op();
    80004354:	fffff097          	auipc	ra,0xfffff
    80004358:	3de080e7          	jalr	990(ra) # 80003732 <end_op>
  p = myproc();
    8000435c:	ffffd097          	auipc	ra,0xffffd
    80004360:	c4e080e7          	jalr	-946(ra) # 80000faa <myproc>
    80004364:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004366:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000436a:	6785                	lui	a5,0x1
    8000436c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000436e:	97ca                	add	a5,a5,s2
    80004370:	777d                	lui	a4,0xfffff
    80004372:	8ff9                	and	a5,a5,a4
    80004374:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004378:	4691                	li	a3,4
    8000437a:	6609                	lui	a2,0x2
    8000437c:	963e                	add	a2,a2,a5
    8000437e:	85be                	mv	a1,a5
    80004380:	855a                	mv	a0,s6
    80004382:	ffffc097          	auipc	ra,0xffffc
    80004386:	5b4080e7          	jalr	1460(ra) # 80000936 <uvmalloc>
    8000438a:	8c2a                	mv	s8,a0
  ip = 0;
    8000438c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000438e:	12050e63          	beqz	a0,800044ca <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004392:	75f9                	lui	a1,0xffffe
    80004394:	95aa                	add	a1,a1,a0
    80004396:	855a                	mv	a0,s6
    80004398:	ffffc097          	auipc	ra,0xffffc
    8000439c:	7ee080e7          	jalr	2030(ra) # 80000b86 <uvmclear>
  stackbase = sp - PGSIZE;
    800043a0:	7afd                	lui	s5,0xfffff
    800043a2:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043a4:	df043783          	ld	a5,-528(s0)
    800043a8:	6388                	ld	a0,0(a5)
    800043aa:	c925                	beqz	a0,8000441a <exec+0x224>
    800043ac:	e9040993          	addi	s3,s0,-368
    800043b0:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043b4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043b6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043b8:	ffffc097          	auipc	ra,0xffffc
    800043bc:	fbc080e7          	jalr	-68(ra) # 80000374 <strlen>
    800043c0:	0015079b          	addiw	a5,a0,1
    800043c4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043c8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043cc:	13596663          	bltu	s2,s5,800044f8 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043d0:	df043d83          	ld	s11,-528(s0)
    800043d4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800043d8:	8552                	mv	a0,s4
    800043da:	ffffc097          	auipc	ra,0xffffc
    800043de:	f9a080e7          	jalr	-102(ra) # 80000374 <strlen>
    800043e2:	0015069b          	addiw	a3,a0,1
    800043e6:	8652                	mv	a2,s4
    800043e8:	85ca                	mv	a1,s2
    800043ea:	855a                	mv	a0,s6
    800043ec:	ffffc097          	auipc	ra,0xffffc
    800043f0:	7f0080e7          	jalr	2032(ra) # 80000bdc <copyout>
    800043f4:	10054663          	bltz	a0,80004500 <exec+0x30a>
    ustack[argc] = sp;
    800043f8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043fc:	0485                	addi	s1,s1,1
    800043fe:	008d8793          	addi	a5,s11,8
    80004402:	def43823          	sd	a5,-528(s0)
    80004406:	008db503          	ld	a0,8(s11)
    8000440a:	c911                	beqz	a0,8000441e <exec+0x228>
    if(argc >= MAXARG)
    8000440c:	09a1                	addi	s3,s3,8
    8000440e:	fb3c95e3          	bne	s9,s3,800043b8 <exec+0x1c2>
  sz = sz1;
    80004412:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004416:	4a81                	li	s5,0
    80004418:	a84d                	j	800044ca <exec+0x2d4>
  sp = sz;
    8000441a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000441c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000441e:	00349793          	slli	a5,s1,0x3
    80004422:	f9078793          	addi	a5,a5,-112
    80004426:	97a2                	add	a5,a5,s0
    80004428:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000442c:	00148693          	addi	a3,s1,1
    80004430:	068e                	slli	a3,a3,0x3
    80004432:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004436:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000443a:	01597663          	bgeu	s2,s5,80004446 <exec+0x250>
  sz = sz1;
    8000443e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004442:	4a81                	li	s5,0
    80004444:	a059                	j	800044ca <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004446:	e9040613          	addi	a2,s0,-368
    8000444a:	85ca                	mv	a1,s2
    8000444c:	855a                	mv	a0,s6
    8000444e:	ffffc097          	auipc	ra,0xffffc
    80004452:	78e080e7          	jalr	1934(ra) # 80000bdc <copyout>
    80004456:	0a054963          	bltz	a0,80004508 <exec+0x312>
  p->trapframe->a1 = sp;
    8000445a:	058bb783          	ld	a5,88(s7)
    8000445e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004462:	de843783          	ld	a5,-536(s0)
    80004466:	0007c703          	lbu	a4,0(a5)
    8000446a:	cf11                	beqz	a4,80004486 <exec+0x290>
    8000446c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000446e:	02f00693          	li	a3,47
    80004472:	a039                	j	80004480 <exec+0x28a>
      last = s+1;
    80004474:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004478:	0785                	addi	a5,a5,1
    8000447a:	fff7c703          	lbu	a4,-1(a5)
    8000447e:	c701                	beqz	a4,80004486 <exec+0x290>
    if(*s == '/')
    80004480:	fed71ce3          	bne	a4,a3,80004478 <exec+0x282>
    80004484:	bfc5                	j	80004474 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004486:	4641                	li	a2,16
    80004488:	de843583          	ld	a1,-536(s0)
    8000448c:	158b8513          	addi	a0,s7,344
    80004490:	ffffc097          	auipc	ra,0xffffc
    80004494:	eb2080e7          	jalr	-334(ra) # 80000342 <safestrcpy>
  oldpagetable = p->pagetable;
    80004498:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000449c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800044a0:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044a4:	058bb783          	ld	a5,88(s7)
    800044a8:	e6843703          	ld	a4,-408(s0)
    800044ac:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044ae:	058bb783          	ld	a5,88(s7)
    800044b2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044b6:	85ea                	mv	a1,s10
    800044b8:	ffffd097          	auipc	ra,0xffffd
    800044bc:	c52080e7          	jalr	-942(ra) # 8000110a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044c0:	0004851b          	sext.w	a0,s1
    800044c4:	b3f9                	j	80004292 <exec+0x9c>
    800044c6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044ca:	df843583          	ld	a1,-520(s0)
    800044ce:	855a                	mv	a0,s6
    800044d0:	ffffd097          	auipc	ra,0xffffd
    800044d4:	c3a080e7          	jalr	-966(ra) # 8000110a <proc_freepagetable>
  if(ip){
    800044d8:	da0a93e3          	bnez	s5,8000427e <exec+0x88>
  return -1;
    800044dc:	557d                	li	a0,-1
    800044de:	bb55                	j	80004292 <exec+0x9c>
    800044e0:	df243c23          	sd	s2,-520(s0)
    800044e4:	b7dd                	j	800044ca <exec+0x2d4>
    800044e6:	df243c23          	sd	s2,-520(s0)
    800044ea:	b7c5                	j	800044ca <exec+0x2d4>
    800044ec:	df243c23          	sd	s2,-520(s0)
    800044f0:	bfe9                	j	800044ca <exec+0x2d4>
    800044f2:	df243c23          	sd	s2,-520(s0)
    800044f6:	bfd1                	j	800044ca <exec+0x2d4>
  sz = sz1;
    800044f8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044fc:	4a81                	li	s5,0
    800044fe:	b7f1                	j	800044ca <exec+0x2d4>
  sz = sz1;
    80004500:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004504:	4a81                	li	s5,0
    80004506:	b7d1                	j	800044ca <exec+0x2d4>
  sz = sz1;
    80004508:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000450c:	4a81                	li	s5,0
    8000450e:	bf75                	j	800044ca <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004510:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004514:	e0843783          	ld	a5,-504(s0)
    80004518:	0017869b          	addiw	a3,a5,1
    8000451c:	e0d43423          	sd	a3,-504(s0)
    80004520:	e0043783          	ld	a5,-512(s0)
    80004524:	0387879b          	addiw	a5,a5,56
    80004528:	e8845703          	lhu	a4,-376(s0)
    8000452c:	e0e6dfe3          	bge	a3,a4,8000434a <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004530:	2781                	sext.w	a5,a5
    80004532:	e0f43023          	sd	a5,-512(s0)
    80004536:	03800713          	li	a4,56
    8000453a:	86be                	mv	a3,a5
    8000453c:	e1840613          	addi	a2,s0,-488
    80004540:	4581                	li	a1,0
    80004542:	8556                	mv	a0,s5
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	a58080e7          	jalr	-1448(ra) # 80002f9c <readi>
    8000454c:	03800793          	li	a5,56
    80004550:	f6f51be3          	bne	a0,a5,800044c6 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80004554:	e1842783          	lw	a5,-488(s0)
    80004558:	4705                	li	a4,1
    8000455a:	fae79de3          	bne	a5,a4,80004514 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    8000455e:	e4043483          	ld	s1,-448(s0)
    80004562:	e3843783          	ld	a5,-456(s0)
    80004566:	f6f4ede3          	bltu	s1,a5,800044e0 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000456a:	e2843783          	ld	a5,-472(s0)
    8000456e:	94be                	add	s1,s1,a5
    80004570:	f6f4ebe3          	bltu	s1,a5,800044e6 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80004574:	de043703          	ld	a4,-544(s0)
    80004578:	8ff9                	and	a5,a5,a4
    8000457a:	fbad                	bnez	a5,800044ec <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000457c:	e1c42503          	lw	a0,-484(s0)
    80004580:	00000097          	auipc	ra,0x0
    80004584:	c5c080e7          	jalr	-932(ra) # 800041dc <flags2perm>
    80004588:	86aa                	mv	a3,a0
    8000458a:	8626                	mv	a2,s1
    8000458c:	85ca                	mv	a1,s2
    8000458e:	855a                	mv	a0,s6
    80004590:	ffffc097          	auipc	ra,0xffffc
    80004594:	3a6080e7          	jalr	934(ra) # 80000936 <uvmalloc>
    80004598:	dea43c23          	sd	a0,-520(s0)
    8000459c:	d939                	beqz	a0,800044f2 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000459e:	e2843c03          	ld	s8,-472(s0)
    800045a2:	e2042c83          	lw	s9,-480(s0)
    800045a6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045aa:	f60b83e3          	beqz	s7,80004510 <exec+0x31a>
    800045ae:	89de                	mv	s3,s7
    800045b0:	4481                	li	s1,0
    800045b2:	bb9d                	j	80004328 <exec+0x132>

00000000800045b4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045b4:	7179                	addi	sp,sp,-48
    800045b6:	f406                	sd	ra,40(sp)
    800045b8:	f022                	sd	s0,32(sp)
    800045ba:	ec26                	sd	s1,24(sp)
    800045bc:	e84a                	sd	s2,16(sp)
    800045be:	1800                	addi	s0,sp,48
    800045c0:	892e                	mv	s2,a1
    800045c2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800045c4:	fdc40593          	addi	a1,s0,-36
    800045c8:	ffffe097          	auipc	ra,0xffffe
    800045cc:	bb6080e7          	jalr	-1098(ra) # 8000217e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045d0:	fdc42703          	lw	a4,-36(s0)
    800045d4:	47bd                	li	a5,15
    800045d6:	02e7eb63          	bltu	a5,a4,8000460c <argfd+0x58>
    800045da:	ffffd097          	auipc	ra,0xffffd
    800045de:	9d0080e7          	jalr	-1584(ra) # 80000faa <myproc>
    800045e2:	fdc42703          	lw	a4,-36(s0)
    800045e6:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7fdbd2aa>
    800045ea:	078e                	slli	a5,a5,0x3
    800045ec:	953e                	add	a0,a0,a5
    800045ee:	611c                	ld	a5,0(a0)
    800045f0:	c385                	beqz	a5,80004610 <argfd+0x5c>
    return -1;
  if(pfd)
    800045f2:	00090463          	beqz	s2,800045fa <argfd+0x46>
    *pfd = fd;
    800045f6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045fa:	4501                	li	a0,0
  if(pf)
    800045fc:	c091                	beqz	s1,80004600 <argfd+0x4c>
    *pf = f;
    800045fe:	e09c                	sd	a5,0(s1)
}
    80004600:	70a2                	ld	ra,40(sp)
    80004602:	7402                	ld	s0,32(sp)
    80004604:	64e2                	ld	s1,24(sp)
    80004606:	6942                	ld	s2,16(sp)
    80004608:	6145                	addi	sp,sp,48
    8000460a:	8082                	ret
    return -1;
    8000460c:	557d                	li	a0,-1
    8000460e:	bfcd                	j	80004600 <argfd+0x4c>
    80004610:	557d                	li	a0,-1
    80004612:	b7fd                	j	80004600 <argfd+0x4c>

0000000080004614 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004614:	1101                	addi	sp,sp,-32
    80004616:	ec06                	sd	ra,24(sp)
    80004618:	e822                	sd	s0,16(sp)
    8000461a:	e426                	sd	s1,8(sp)
    8000461c:	1000                	addi	s0,sp,32
    8000461e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004620:	ffffd097          	auipc	ra,0xffffd
    80004624:	98a080e7          	jalr	-1654(ra) # 80000faa <myproc>
    80004628:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000462a:	0d050793          	addi	a5,a0,208
    8000462e:	4501                	li	a0,0
    80004630:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004632:	6398                	ld	a4,0(a5)
    80004634:	cb19                	beqz	a4,8000464a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004636:	2505                	addiw	a0,a0,1
    80004638:	07a1                	addi	a5,a5,8
    8000463a:	fed51ce3          	bne	a0,a3,80004632 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000463e:	557d                	li	a0,-1
}
    80004640:	60e2                	ld	ra,24(sp)
    80004642:	6442                	ld	s0,16(sp)
    80004644:	64a2                	ld	s1,8(sp)
    80004646:	6105                	addi	sp,sp,32
    80004648:	8082                	ret
      p->ofile[fd] = f;
    8000464a:	01a50793          	addi	a5,a0,26
    8000464e:	078e                	slli	a5,a5,0x3
    80004650:	963e                	add	a2,a2,a5
    80004652:	e204                	sd	s1,0(a2)
      return fd;
    80004654:	b7f5                	j	80004640 <fdalloc+0x2c>

0000000080004656 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004656:	715d                	addi	sp,sp,-80
    80004658:	e486                	sd	ra,72(sp)
    8000465a:	e0a2                	sd	s0,64(sp)
    8000465c:	fc26                	sd	s1,56(sp)
    8000465e:	f84a                	sd	s2,48(sp)
    80004660:	f44e                	sd	s3,40(sp)
    80004662:	f052                	sd	s4,32(sp)
    80004664:	ec56                	sd	s5,24(sp)
    80004666:	e85a                	sd	s6,16(sp)
    80004668:	0880                	addi	s0,sp,80
    8000466a:	8b2e                	mv	s6,a1
    8000466c:	89b2                	mv	s3,a2
    8000466e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004670:	fb040593          	addi	a1,s0,-80
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	e3e080e7          	jalr	-450(ra) # 800034b2 <nameiparent>
    8000467c:	84aa                	mv	s1,a0
    8000467e:	14050f63          	beqz	a0,800047dc <create+0x186>
    return 0;

  ilock(dp);
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	666080e7          	jalr	1638(ra) # 80002ce8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000468a:	4601                	li	a2,0
    8000468c:	fb040593          	addi	a1,s0,-80
    80004690:	8526                	mv	a0,s1
    80004692:	fffff097          	auipc	ra,0xfffff
    80004696:	b3a080e7          	jalr	-1222(ra) # 800031cc <dirlookup>
    8000469a:	8aaa                	mv	s5,a0
    8000469c:	c931                	beqz	a0,800046f0 <create+0x9a>
    iunlockput(dp);
    8000469e:	8526                	mv	a0,s1
    800046a0:	fffff097          	auipc	ra,0xfffff
    800046a4:	8aa080e7          	jalr	-1878(ra) # 80002f4a <iunlockput>
    ilock(ip);
    800046a8:	8556                	mv	a0,s5
    800046aa:	ffffe097          	auipc	ra,0xffffe
    800046ae:	63e080e7          	jalr	1598(ra) # 80002ce8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046b2:	000b059b          	sext.w	a1,s6
    800046b6:	4789                	li	a5,2
    800046b8:	02f59563          	bne	a1,a5,800046e2 <create+0x8c>
    800046bc:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdbd2d4>
    800046c0:	37f9                	addiw	a5,a5,-2
    800046c2:	17c2                	slli	a5,a5,0x30
    800046c4:	93c1                	srli	a5,a5,0x30
    800046c6:	4705                	li	a4,1
    800046c8:	00f76d63          	bltu	a4,a5,800046e2 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800046cc:	8556                	mv	a0,s5
    800046ce:	60a6                	ld	ra,72(sp)
    800046d0:	6406                	ld	s0,64(sp)
    800046d2:	74e2                	ld	s1,56(sp)
    800046d4:	7942                	ld	s2,48(sp)
    800046d6:	79a2                	ld	s3,40(sp)
    800046d8:	7a02                	ld	s4,32(sp)
    800046da:	6ae2                	ld	s5,24(sp)
    800046dc:	6b42                	ld	s6,16(sp)
    800046de:	6161                	addi	sp,sp,80
    800046e0:	8082                	ret
    iunlockput(ip);
    800046e2:	8556                	mv	a0,s5
    800046e4:	fffff097          	auipc	ra,0xfffff
    800046e8:	866080e7          	jalr	-1946(ra) # 80002f4a <iunlockput>
    return 0;
    800046ec:	4a81                	li	s5,0
    800046ee:	bff9                	j	800046cc <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800046f0:	85da                	mv	a1,s6
    800046f2:	4088                	lw	a0,0(s1)
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	456080e7          	jalr	1110(ra) # 80002b4a <ialloc>
    800046fc:	8a2a                	mv	s4,a0
    800046fe:	c539                	beqz	a0,8000474c <create+0xf6>
  ilock(ip);
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	5e8080e7          	jalr	1512(ra) # 80002ce8 <ilock>
  ip->major = major;
    80004708:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000470c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004710:	4905                	li	s2,1
    80004712:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004716:	8552                	mv	a0,s4
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	504080e7          	jalr	1284(ra) # 80002c1c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004720:	000b059b          	sext.w	a1,s6
    80004724:	03258b63          	beq	a1,s2,8000475a <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004728:	004a2603          	lw	a2,4(s4)
    8000472c:	fb040593          	addi	a1,s0,-80
    80004730:	8526                	mv	a0,s1
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	cb0080e7          	jalr	-848(ra) # 800033e2 <dirlink>
    8000473a:	06054f63          	bltz	a0,800047b8 <create+0x162>
  iunlockput(dp);
    8000473e:	8526                	mv	a0,s1
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	80a080e7          	jalr	-2038(ra) # 80002f4a <iunlockput>
  return ip;
    80004748:	8ad2                	mv	s5,s4
    8000474a:	b749                	j	800046cc <create+0x76>
    iunlockput(dp);
    8000474c:	8526                	mv	a0,s1
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	7fc080e7          	jalr	2044(ra) # 80002f4a <iunlockput>
    return 0;
    80004756:	8ad2                	mv	s5,s4
    80004758:	bf95                	j	800046cc <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000475a:	004a2603          	lw	a2,4(s4)
    8000475e:	00004597          	auipc	a1,0x4
    80004762:	f1258593          	addi	a1,a1,-238 # 80008670 <syscalls+0x2a0>
    80004766:	8552                	mv	a0,s4
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	c7a080e7          	jalr	-902(ra) # 800033e2 <dirlink>
    80004770:	04054463          	bltz	a0,800047b8 <create+0x162>
    80004774:	40d0                	lw	a2,4(s1)
    80004776:	00004597          	auipc	a1,0x4
    8000477a:	f0258593          	addi	a1,a1,-254 # 80008678 <syscalls+0x2a8>
    8000477e:	8552                	mv	a0,s4
    80004780:	fffff097          	auipc	ra,0xfffff
    80004784:	c62080e7          	jalr	-926(ra) # 800033e2 <dirlink>
    80004788:	02054863          	bltz	a0,800047b8 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    8000478c:	004a2603          	lw	a2,4(s4)
    80004790:	fb040593          	addi	a1,s0,-80
    80004794:	8526                	mv	a0,s1
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	c4c080e7          	jalr	-948(ra) # 800033e2 <dirlink>
    8000479e:	00054d63          	bltz	a0,800047b8 <create+0x162>
    dp->nlink++;  // for ".."
    800047a2:	04a4d783          	lhu	a5,74(s1)
    800047a6:	2785                	addiw	a5,a5,1
    800047a8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047ac:	8526                	mv	a0,s1
    800047ae:	ffffe097          	auipc	ra,0xffffe
    800047b2:	46e080e7          	jalr	1134(ra) # 80002c1c <iupdate>
    800047b6:	b761                	j	8000473e <create+0xe8>
  ip->nlink = 0;
    800047b8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047bc:	8552                	mv	a0,s4
    800047be:	ffffe097          	auipc	ra,0xffffe
    800047c2:	45e080e7          	jalr	1118(ra) # 80002c1c <iupdate>
  iunlockput(ip);
    800047c6:	8552                	mv	a0,s4
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	782080e7          	jalr	1922(ra) # 80002f4a <iunlockput>
  iunlockput(dp);
    800047d0:	8526                	mv	a0,s1
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	778080e7          	jalr	1912(ra) # 80002f4a <iunlockput>
  return 0;
    800047da:	bdcd                	j	800046cc <create+0x76>
    return 0;
    800047dc:	8aaa                	mv	s5,a0
    800047de:	b5fd                	j	800046cc <create+0x76>

00000000800047e0 <sys_dup>:
{
    800047e0:	7179                	addi	sp,sp,-48
    800047e2:	f406                	sd	ra,40(sp)
    800047e4:	f022                	sd	s0,32(sp)
    800047e6:	ec26                	sd	s1,24(sp)
    800047e8:	e84a                	sd	s2,16(sp)
    800047ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047ec:	fd840613          	addi	a2,s0,-40
    800047f0:	4581                	li	a1,0
    800047f2:	4501                	li	a0,0
    800047f4:	00000097          	auipc	ra,0x0
    800047f8:	dc0080e7          	jalr	-576(ra) # 800045b4 <argfd>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047fe:	02054363          	bltz	a0,80004824 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004802:	fd843903          	ld	s2,-40(s0)
    80004806:	854a                	mv	a0,s2
    80004808:	00000097          	auipc	ra,0x0
    8000480c:	e0c080e7          	jalr	-500(ra) # 80004614 <fdalloc>
    80004810:	84aa                	mv	s1,a0
    return -1;
    80004812:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004814:	00054863          	bltz	a0,80004824 <sys_dup+0x44>
  filedup(f);
    80004818:	854a                	mv	a0,s2
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	310080e7          	jalr	784(ra) # 80003b2a <filedup>
  return fd;
    80004822:	87a6                	mv	a5,s1
}
    80004824:	853e                	mv	a0,a5
    80004826:	70a2                	ld	ra,40(sp)
    80004828:	7402                	ld	s0,32(sp)
    8000482a:	64e2                	ld	s1,24(sp)
    8000482c:	6942                	ld	s2,16(sp)
    8000482e:	6145                	addi	sp,sp,48
    80004830:	8082                	ret

0000000080004832 <sys_read>:
{
    80004832:	7179                	addi	sp,sp,-48
    80004834:	f406                	sd	ra,40(sp)
    80004836:	f022                	sd	s0,32(sp)
    80004838:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000483a:	fd840593          	addi	a1,s0,-40
    8000483e:	4505                	li	a0,1
    80004840:	ffffe097          	auipc	ra,0xffffe
    80004844:	95e080e7          	jalr	-1698(ra) # 8000219e <argaddr>
  argint(2, &n);
    80004848:	fe440593          	addi	a1,s0,-28
    8000484c:	4509                	li	a0,2
    8000484e:	ffffe097          	auipc	ra,0xffffe
    80004852:	930080e7          	jalr	-1744(ra) # 8000217e <argint>
  if(argfd(0, 0, &f) < 0)
    80004856:	fe840613          	addi	a2,s0,-24
    8000485a:	4581                	li	a1,0
    8000485c:	4501                	li	a0,0
    8000485e:	00000097          	auipc	ra,0x0
    80004862:	d56080e7          	jalr	-682(ra) # 800045b4 <argfd>
    80004866:	87aa                	mv	a5,a0
    return -1;
    80004868:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000486a:	0007cc63          	bltz	a5,80004882 <sys_read+0x50>
  return fileread(f, p, n);
    8000486e:	fe442603          	lw	a2,-28(s0)
    80004872:	fd843583          	ld	a1,-40(s0)
    80004876:	fe843503          	ld	a0,-24(s0)
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	43c080e7          	jalr	1084(ra) # 80003cb6 <fileread>
}
    80004882:	70a2                	ld	ra,40(sp)
    80004884:	7402                	ld	s0,32(sp)
    80004886:	6145                	addi	sp,sp,48
    80004888:	8082                	ret

000000008000488a <sys_write>:
{
    8000488a:	7179                	addi	sp,sp,-48
    8000488c:	f406                	sd	ra,40(sp)
    8000488e:	f022                	sd	s0,32(sp)
    80004890:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004892:	fd840593          	addi	a1,s0,-40
    80004896:	4505                	li	a0,1
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	906080e7          	jalr	-1786(ra) # 8000219e <argaddr>
  argint(2, &n);
    800048a0:	fe440593          	addi	a1,s0,-28
    800048a4:	4509                	li	a0,2
    800048a6:	ffffe097          	auipc	ra,0xffffe
    800048aa:	8d8080e7          	jalr	-1832(ra) # 8000217e <argint>
  if(argfd(0, 0, &f) < 0)
    800048ae:	fe840613          	addi	a2,s0,-24
    800048b2:	4581                	li	a1,0
    800048b4:	4501                	li	a0,0
    800048b6:	00000097          	auipc	ra,0x0
    800048ba:	cfe080e7          	jalr	-770(ra) # 800045b4 <argfd>
    800048be:	87aa                	mv	a5,a0
    return -1;
    800048c0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048c2:	0007cc63          	bltz	a5,800048da <sys_write+0x50>
  return filewrite(f, p, n);
    800048c6:	fe442603          	lw	a2,-28(s0)
    800048ca:	fd843583          	ld	a1,-40(s0)
    800048ce:	fe843503          	ld	a0,-24(s0)
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	4a6080e7          	jalr	1190(ra) # 80003d78 <filewrite>
}
    800048da:	70a2                	ld	ra,40(sp)
    800048dc:	7402                	ld	s0,32(sp)
    800048de:	6145                	addi	sp,sp,48
    800048e0:	8082                	ret

00000000800048e2 <sys_close>:
{
    800048e2:	1101                	addi	sp,sp,-32
    800048e4:	ec06                	sd	ra,24(sp)
    800048e6:	e822                	sd	s0,16(sp)
    800048e8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048ea:	fe040613          	addi	a2,s0,-32
    800048ee:	fec40593          	addi	a1,s0,-20
    800048f2:	4501                	li	a0,0
    800048f4:	00000097          	auipc	ra,0x0
    800048f8:	cc0080e7          	jalr	-832(ra) # 800045b4 <argfd>
    return -1;
    800048fc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048fe:	02054463          	bltz	a0,80004926 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004902:	ffffc097          	auipc	ra,0xffffc
    80004906:	6a8080e7          	jalr	1704(ra) # 80000faa <myproc>
    8000490a:	fec42783          	lw	a5,-20(s0)
    8000490e:	07e9                	addi	a5,a5,26
    80004910:	078e                	slli	a5,a5,0x3
    80004912:	953e                	add	a0,a0,a5
    80004914:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004918:	fe043503          	ld	a0,-32(s0)
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	260080e7          	jalr	608(ra) # 80003b7c <fileclose>
  return 0;
    80004924:	4781                	li	a5,0
}
    80004926:	853e                	mv	a0,a5
    80004928:	60e2                	ld	ra,24(sp)
    8000492a:	6442                	ld	s0,16(sp)
    8000492c:	6105                	addi	sp,sp,32
    8000492e:	8082                	ret

0000000080004930 <sys_fstat>:
{
    80004930:	1101                	addi	sp,sp,-32
    80004932:	ec06                	sd	ra,24(sp)
    80004934:	e822                	sd	s0,16(sp)
    80004936:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004938:	fe040593          	addi	a1,s0,-32
    8000493c:	4505                	li	a0,1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	860080e7          	jalr	-1952(ra) # 8000219e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004946:	fe840613          	addi	a2,s0,-24
    8000494a:	4581                	li	a1,0
    8000494c:	4501                	li	a0,0
    8000494e:	00000097          	auipc	ra,0x0
    80004952:	c66080e7          	jalr	-922(ra) # 800045b4 <argfd>
    80004956:	87aa                	mv	a5,a0
    return -1;
    80004958:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000495a:	0007ca63          	bltz	a5,8000496e <sys_fstat+0x3e>
  return filestat(f, st);
    8000495e:	fe043583          	ld	a1,-32(s0)
    80004962:	fe843503          	ld	a0,-24(s0)
    80004966:	fffff097          	auipc	ra,0xfffff
    8000496a:	2de080e7          	jalr	734(ra) # 80003c44 <filestat>
}
    8000496e:	60e2                	ld	ra,24(sp)
    80004970:	6442                	ld	s0,16(sp)
    80004972:	6105                	addi	sp,sp,32
    80004974:	8082                	ret

0000000080004976 <sys_link>:
{
    80004976:	7169                	addi	sp,sp,-304
    80004978:	f606                	sd	ra,296(sp)
    8000497a:	f222                	sd	s0,288(sp)
    8000497c:	ee26                	sd	s1,280(sp)
    8000497e:	ea4a                	sd	s2,272(sp)
    80004980:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004982:	08000613          	li	a2,128
    80004986:	ed040593          	addi	a1,s0,-304
    8000498a:	4501                	li	a0,0
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	832080e7          	jalr	-1998(ra) # 800021be <argstr>
    return -1;
    80004994:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004996:	10054e63          	bltz	a0,80004ab2 <sys_link+0x13c>
    8000499a:	08000613          	li	a2,128
    8000499e:	f5040593          	addi	a1,s0,-176
    800049a2:	4505                	li	a0,1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	81a080e7          	jalr	-2022(ra) # 800021be <argstr>
    return -1;
    800049ac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ae:	10054263          	bltz	a0,80004ab2 <sys_link+0x13c>
  begin_op();
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	d02080e7          	jalr	-766(ra) # 800036b4 <begin_op>
  if((ip = namei(old)) == 0){
    800049ba:	ed040513          	addi	a0,s0,-304
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	ad6080e7          	jalr	-1322(ra) # 80003494 <namei>
    800049c6:	84aa                	mv	s1,a0
    800049c8:	c551                	beqz	a0,80004a54 <sys_link+0xde>
  ilock(ip);
    800049ca:	ffffe097          	auipc	ra,0xffffe
    800049ce:	31e080e7          	jalr	798(ra) # 80002ce8 <ilock>
  if(ip->type == T_DIR){
    800049d2:	04449703          	lh	a4,68(s1)
    800049d6:	4785                	li	a5,1
    800049d8:	08f70463          	beq	a4,a5,80004a60 <sys_link+0xea>
  ip->nlink++;
    800049dc:	04a4d783          	lhu	a5,74(s1)
    800049e0:	2785                	addiw	a5,a5,1
    800049e2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049e6:	8526                	mv	a0,s1
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	234080e7          	jalr	564(ra) # 80002c1c <iupdate>
  iunlock(ip);
    800049f0:	8526                	mv	a0,s1
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	3b8080e7          	jalr	952(ra) # 80002daa <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049fa:	fd040593          	addi	a1,s0,-48
    800049fe:	f5040513          	addi	a0,s0,-176
    80004a02:	fffff097          	auipc	ra,0xfffff
    80004a06:	ab0080e7          	jalr	-1360(ra) # 800034b2 <nameiparent>
    80004a0a:	892a                	mv	s2,a0
    80004a0c:	c935                	beqz	a0,80004a80 <sys_link+0x10a>
  ilock(dp);
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	2da080e7          	jalr	730(ra) # 80002ce8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a16:	00092703          	lw	a4,0(s2)
    80004a1a:	409c                	lw	a5,0(s1)
    80004a1c:	04f71d63          	bne	a4,a5,80004a76 <sys_link+0x100>
    80004a20:	40d0                	lw	a2,4(s1)
    80004a22:	fd040593          	addi	a1,s0,-48
    80004a26:	854a                	mv	a0,s2
    80004a28:	fffff097          	auipc	ra,0xfffff
    80004a2c:	9ba080e7          	jalr	-1606(ra) # 800033e2 <dirlink>
    80004a30:	04054363          	bltz	a0,80004a76 <sys_link+0x100>
  iunlockput(dp);
    80004a34:	854a                	mv	a0,s2
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	514080e7          	jalr	1300(ra) # 80002f4a <iunlockput>
  iput(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	462080e7          	jalr	1122(ra) # 80002ea2 <iput>
  end_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	cea080e7          	jalr	-790(ra) # 80003732 <end_op>
  return 0;
    80004a50:	4781                	li	a5,0
    80004a52:	a085                	j	80004ab2 <sys_link+0x13c>
    end_op();
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	cde080e7          	jalr	-802(ra) # 80003732 <end_op>
    return -1;
    80004a5c:	57fd                	li	a5,-1
    80004a5e:	a891                	j	80004ab2 <sys_link+0x13c>
    iunlockput(ip);
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	4e8080e7          	jalr	1256(ra) # 80002f4a <iunlockput>
    end_op();
    80004a6a:	fffff097          	auipc	ra,0xfffff
    80004a6e:	cc8080e7          	jalr	-824(ra) # 80003732 <end_op>
    return -1;
    80004a72:	57fd                	li	a5,-1
    80004a74:	a83d                	j	80004ab2 <sys_link+0x13c>
    iunlockput(dp);
    80004a76:	854a                	mv	a0,s2
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	4d2080e7          	jalr	1234(ra) # 80002f4a <iunlockput>
  ilock(ip);
    80004a80:	8526                	mv	a0,s1
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	266080e7          	jalr	614(ra) # 80002ce8 <ilock>
  ip->nlink--;
    80004a8a:	04a4d783          	lhu	a5,74(s1)
    80004a8e:	37fd                	addiw	a5,a5,-1
    80004a90:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	186080e7          	jalr	390(ra) # 80002c1c <iupdate>
  iunlockput(ip);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	4aa080e7          	jalr	1194(ra) # 80002f4a <iunlockput>
  end_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	c8a080e7          	jalr	-886(ra) # 80003732 <end_op>
  return -1;
    80004ab0:	57fd                	li	a5,-1
}
    80004ab2:	853e                	mv	a0,a5
    80004ab4:	70b2                	ld	ra,296(sp)
    80004ab6:	7412                	ld	s0,288(sp)
    80004ab8:	64f2                	ld	s1,280(sp)
    80004aba:	6952                	ld	s2,272(sp)
    80004abc:	6155                	addi	sp,sp,304
    80004abe:	8082                	ret

0000000080004ac0 <sys_unlink>:
{
    80004ac0:	7151                	addi	sp,sp,-240
    80004ac2:	f586                	sd	ra,232(sp)
    80004ac4:	f1a2                	sd	s0,224(sp)
    80004ac6:	eda6                	sd	s1,216(sp)
    80004ac8:	e9ca                	sd	s2,208(sp)
    80004aca:	e5ce                	sd	s3,200(sp)
    80004acc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ace:	08000613          	li	a2,128
    80004ad2:	f3040593          	addi	a1,s0,-208
    80004ad6:	4501                	li	a0,0
    80004ad8:	ffffd097          	auipc	ra,0xffffd
    80004adc:	6e6080e7          	jalr	1766(ra) # 800021be <argstr>
    80004ae0:	18054163          	bltz	a0,80004c62 <sys_unlink+0x1a2>
  begin_op();
    80004ae4:	fffff097          	auipc	ra,0xfffff
    80004ae8:	bd0080e7          	jalr	-1072(ra) # 800036b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004aec:	fb040593          	addi	a1,s0,-80
    80004af0:	f3040513          	addi	a0,s0,-208
    80004af4:	fffff097          	auipc	ra,0xfffff
    80004af8:	9be080e7          	jalr	-1602(ra) # 800034b2 <nameiparent>
    80004afc:	84aa                	mv	s1,a0
    80004afe:	c979                	beqz	a0,80004bd4 <sys_unlink+0x114>
  ilock(dp);
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	1e8080e7          	jalr	488(ra) # 80002ce8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b08:	00004597          	auipc	a1,0x4
    80004b0c:	b6858593          	addi	a1,a1,-1176 # 80008670 <syscalls+0x2a0>
    80004b10:	fb040513          	addi	a0,s0,-80
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	69e080e7          	jalr	1694(ra) # 800031b2 <namecmp>
    80004b1c:	14050a63          	beqz	a0,80004c70 <sys_unlink+0x1b0>
    80004b20:	00004597          	auipc	a1,0x4
    80004b24:	b5858593          	addi	a1,a1,-1192 # 80008678 <syscalls+0x2a8>
    80004b28:	fb040513          	addi	a0,s0,-80
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	686080e7          	jalr	1670(ra) # 800031b2 <namecmp>
    80004b34:	12050e63          	beqz	a0,80004c70 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b38:	f2c40613          	addi	a2,s0,-212
    80004b3c:	fb040593          	addi	a1,s0,-80
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	68a080e7          	jalr	1674(ra) # 800031cc <dirlookup>
    80004b4a:	892a                	mv	s2,a0
    80004b4c:	12050263          	beqz	a0,80004c70 <sys_unlink+0x1b0>
  ilock(ip);
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	198080e7          	jalr	408(ra) # 80002ce8 <ilock>
  if(ip->nlink < 1)
    80004b58:	04a91783          	lh	a5,74(s2)
    80004b5c:	08f05263          	blez	a5,80004be0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b60:	04491703          	lh	a4,68(s2)
    80004b64:	4785                	li	a5,1
    80004b66:	08f70563          	beq	a4,a5,80004bf0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b6a:	4641                	li	a2,16
    80004b6c:	4581                	li	a1,0
    80004b6e:	fc040513          	addi	a0,s0,-64
    80004b72:	ffffb097          	auipc	ra,0xffffb
    80004b76:	686080e7          	jalr	1670(ra) # 800001f8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7a:	4741                	li	a4,16
    80004b7c:	f2c42683          	lw	a3,-212(s0)
    80004b80:	fc040613          	addi	a2,s0,-64
    80004b84:	4581                	li	a1,0
    80004b86:	8526                	mv	a0,s1
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	50c080e7          	jalr	1292(ra) # 80003094 <writei>
    80004b90:	47c1                	li	a5,16
    80004b92:	0af51563          	bne	a0,a5,80004c3c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b96:	04491703          	lh	a4,68(s2)
    80004b9a:	4785                	li	a5,1
    80004b9c:	0af70863          	beq	a4,a5,80004c4c <sys_unlink+0x18c>
  iunlockput(dp);
    80004ba0:	8526                	mv	a0,s1
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	3a8080e7          	jalr	936(ra) # 80002f4a <iunlockput>
  ip->nlink--;
    80004baa:	04a95783          	lhu	a5,74(s2)
    80004bae:	37fd                	addiw	a5,a5,-1
    80004bb0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bb4:	854a                	mv	a0,s2
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	066080e7          	jalr	102(ra) # 80002c1c <iupdate>
  iunlockput(ip);
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	38a080e7          	jalr	906(ra) # 80002f4a <iunlockput>
  end_op();
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	b6a080e7          	jalr	-1174(ra) # 80003732 <end_op>
  return 0;
    80004bd0:	4501                	li	a0,0
    80004bd2:	a84d                	j	80004c84 <sys_unlink+0x1c4>
    end_op();
    80004bd4:	fffff097          	auipc	ra,0xfffff
    80004bd8:	b5e080e7          	jalr	-1186(ra) # 80003732 <end_op>
    return -1;
    80004bdc:	557d                	li	a0,-1
    80004bde:	a05d                	j	80004c84 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004be0:	00004517          	auipc	a0,0x4
    80004be4:	aa050513          	addi	a0,a0,-1376 # 80008680 <syscalls+0x2b0>
    80004be8:	00001097          	auipc	ra,0x1
    80004bec:	1b4080e7          	jalr	436(ra) # 80005d9c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bf0:	04c92703          	lw	a4,76(s2)
    80004bf4:	02000793          	li	a5,32
    80004bf8:	f6e7f9e3          	bgeu	a5,a4,80004b6a <sys_unlink+0xaa>
    80004bfc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c00:	4741                	li	a4,16
    80004c02:	86ce                	mv	a3,s3
    80004c04:	f1840613          	addi	a2,s0,-232
    80004c08:	4581                	li	a1,0
    80004c0a:	854a                	mv	a0,s2
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	390080e7          	jalr	912(ra) # 80002f9c <readi>
    80004c14:	47c1                	li	a5,16
    80004c16:	00f51b63          	bne	a0,a5,80004c2c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c1a:	f1845783          	lhu	a5,-232(s0)
    80004c1e:	e7a1                	bnez	a5,80004c66 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c20:	29c1                	addiw	s3,s3,16
    80004c22:	04c92783          	lw	a5,76(s2)
    80004c26:	fcf9ede3          	bltu	s3,a5,80004c00 <sys_unlink+0x140>
    80004c2a:	b781                	j	80004b6a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c2c:	00004517          	auipc	a0,0x4
    80004c30:	a6c50513          	addi	a0,a0,-1428 # 80008698 <syscalls+0x2c8>
    80004c34:	00001097          	auipc	ra,0x1
    80004c38:	168080e7          	jalr	360(ra) # 80005d9c <panic>
    panic("unlink: writei");
    80004c3c:	00004517          	auipc	a0,0x4
    80004c40:	a7450513          	addi	a0,a0,-1420 # 800086b0 <syscalls+0x2e0>
    80004c44:	00001097          	auipc	ra,0x1
    80004c48:	158080e7          	jalr	344(ra) # 80005d9c <panic>
    dp->nlink--;
    80004c4c:	04a4d783          	lhu	a5,74(s1)
    80004c50:	37fd                	addiw	a5,a5,-1
    80004c52:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	fc4080e7          	jalr	-60(ra) # 80002c1c <iupdate>
    80004c60:	b781                	j	80004ba0 <sys_unlink+0xe0>
    return -1;
    80004c62:	557d                	li	a0,-1
    80004c64:	a005                	j	80004c84 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	2e2080e7          	jalr	738(ra) # 80002f4a <iunlockput>
  iunlockput(dp);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	2d8080e7          	jalr	728(ra) # 80002f4a <iunlockput>
  end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	ab8080e7          	jalr	-1352(ra) # 80003732 <end_op>
  return -1;
    80004c82:	557d                	li	a0,-1
}
    80004c84:	70ae                	ld	ra,232(sp)
    80004c86:	740e                	ld	s0,224(sp)
    80004c88:	64ee                	ld	s1,216(sp)
    80004c8a:	694e                	ld	s2,208(sp)
    80004c8c:	69ae                	ld	s3,200(sp)
    80004c8e:	616d                	addi	sp,sp,240
    80004c90:	8082                	ret

0000000080004c92 <sys_open>:

uint64
sys_open(void)
{
    80004c92:	7131                	addi	sp,sp,-192
    80004c94:	fd06                	sd	ra,184(sp)
    80004c96:	f922                	sd	s0,176(sp)
    80004c98:	f526                	sd	s1,168(sp)
    80004c9a:	f14a                	sd	s2,160(sp)
    80004c9c:	ed4e                	sd	s3,152(sp)
    80004c9e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ca0:	f4c40593          	addi	a1,s0,-180
    80004ca4:	4505                	li	a0,1
    80004ca6:	ffffd097          	auipc	ra,0xffffd
    80004caa:	4d8080e7          	jalr	1240(ra) # 8000217e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cae:	08000613          	li	a2,128
    80004cb2:	f5040593          	addi	a1,s0,-176
    80004cb6:	4501                	li	a0,0
    80004cb8:	ffffd097          	auipc	ra,0xffffd
    80004cbc:	506080e7          	jalr	1286(ra) # 800021be <argstr>
    80004cc0:	87aa                	mv	a5,a0
    return -1;
    80004cc2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cc4:	0a07c963          	bltz	a5,80004d76 <sys_open+0xe4>

  begin_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	9ec080e7          	jalr	-1556(ra) # 800036b4 <begin_op>

  if(omode & O_CREATE){
    80004cd0:	f4c42783          	lw	a5,-180(s0)
    80004cd4:	2007f793          	andi	a5,a5,512
    80004cd8:	cfc5                	beqz	a5,80004d90 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cda:	4681                	li	a3,0
    80004cdc:	4601                	li	a2,0
    80004cde:	4589                	li	a1,2
    80004ce0:	f5040513          	addi	a0,s0,-176
    80004ce4:	00000097          	auipc	ra,0x0
    80004ce8:	972080e7          	jalr	-1678(ra) # 80004656 <create>
    80004cec:	84aa                	mv	s1,a0
    if(ip == 0){
    80004cee:	c959                	beqz	a0,80004d84 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cf0:	04449703          	lh	a4,68(s1)
    80004cf4:	478d                	li	a5,3
    80004cf6:	00f71763          	bne	a4,a5,80004d04 <sys_open+0x72>
    80004cfa:	0464d703          	lhu	a4,70(s1)
    80004cfe:	47a5                	li	a5,9
    80004d00:	0ce7ed63          	bltu	a5,a4,80004dda <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	dbc080e7          	jalr	-580(ra) # 80003ac0 <filealloc>
    80004d0c:	89aa                	mv	s3,a0
    80004d0e:	10050363          	beqz	a0,80004e14 <sys_open+0x182>
    80004d12:	00000097          	auipc	ra,0x0
    80004d16:	902080e7          	jalr	-1790(ra) # 80004614 <fdalloc>
    80004d1a:	892a                	mv	s2,a0
    80004d1c:	0e054763          	bltz	a0,80004e0a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d20:	04449703          	lh	a4,68(s1)
    80004d24:	478d                	li	a5,3
    80004d26:	0cf70563          	beq	a4,a5,80004df0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d2a:	4789                	li	a5,2
    80004d2c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d30:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d34:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d38:	f4c42783          	lw	a5,-180(s0)
    80004d3c:	0017c713          	xori	a4,a5,1
    80004d40:	8b05                	andi	a4,a4,1
    80004d42:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d46:	0037f713          	andi	a4,a5,3
    80004d4a:	00e03733          	snez	a4,a4
    80004d4e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d52:	4007f793          	andi	a5,a5,1024
    80004d56:	c791                	beqz	a5,80004d62 <sys_open+0xd0>
    80004d58:	04449703          	lh	a4,68(s1)
    80004d5c:	4789                	li	a5,2
    80004d5e:	0af70063          	beq	a4,a5,80004dfe <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d62:	8526                	mv	a0,s1
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	046080e7          	jalr	70(ra) # 80002daa <iunlock>
  end_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	9c6080e7          	jalr	-1594(ra) # 80003732 <end_op>

  return fd;
    80004d74:	854a                	mv	a0,s2
}
    80004d76:	70ea                	ld	ra,184(sp)
    80004d78:	744a                	ld	s0,176(sp)
    80004d7a:	74aa                	ld	s1,168(sp)
    80004d7c:	790a                	ld	s2,160(sp)
    80004d7e:	69ea                	ld	s3,152(sp)
    80004d80:	6129                	addi	sp,sp,192
    80004d82:	8082                	ret
      end_op();
    80004d84:	fffff097          	auipc	ra,0xfffff
    80004d88:	9ae080e7          	jalr	-1618(ra) # 80003732 <end_op>
      return -1;
    80004d8c:	557d                	li	a0,-1
    80004d8e:	b7e5                	j	80004d76 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d90:	f5040513          	addi	a0,s0,-176
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	700080e7          	jalr	1792(ra) # 80003494 <namei>
    80004d9c:	84aa                	mv	s1,a0
    80004d9e:	c905                	beqz	a0,80004dce <sys_open+0x13c>
    ilock(ip);
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	f48080e7          	jalr	-184(ra) # 80002ce8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004da8:	04449703          	lh	a4,68(s1)
    80004dac:	4785                	li	a5,1
    80004dae:	f4f711e3          	bne	a4,a5,80004cf0 <sys_open+0x5e>
    80004db2:	f4c42783          	lw	a5,-180(s0)
    80004db6:	d7b9                	beqz	a5,80004d04 <sys_open+0x72>
      iunlockput(ip);
    80004db8:	8526                	mv	a0,s1
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	190080e7          	jalr	400(ra) # 80002f4a <iunlockput>
      end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	970080e7          	jalr	-1680(ra) # 80003732 <end_op>
      return -1;
    80004dca:	557d                	li	a0,-1
    80004dcc:	b76d                	j	80004d76 <sys_open+0xe4>
      end_op();
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	964080e7          	jalr	-1692(ra) # 80003732 <end_op>
      return -1;
    80004dd6:	557d                	li	a0,-1
    80004dd8:	bf79                	j	80004d76 <sys_open+0xe4>
    iunlockput(ip);
    80004dda:	8526                	mv	a0,s1
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	16e080e7          	jalr	366(ra) # 80002f4a <iunlockput>
    end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	94e080e7          	jalr	-1714(ra) # 80003732 <end_op>
    return -1;
    80004dec:	557d                	li	a0,-1
    80004dee:	b761                	j	80004d76 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004df0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004df4:	04649783          	lh	a5,70(s1)
    80004df8:	02f99223          	sh	a5,36(s3)
    80004dfc:	bf25                	j	80004d34 <sys_open+0xa2>
    itrunc(ip);
    80004dfe:	8526                	mv	a0,s1
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	ff6080e7          	jalr	-10(ra) # 80002df6 <itrunc>
    80004e08:	bfa9                	j	80004d62 <sys_open+0xd0>
      fileclose(f);
    80004e0a:	854e                	mv	a0,s3
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	d70080e7          	jalr	-656(ra) # 80003b7c <fileclose>
    iunlockput(ip);
    80004e14:	8526                	mv	a0,s1
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	134080e7          	jalr	308(ra) # 80002f4a <iunlockput>
    end_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	914080e7          	jalr	-1772(ra) # 80003732 <end_op>
    return -1;
    80004e26:	557d                	li	a0,-1
    80004e28:	b7b9                	j	80004d76 <sys_open+0xe4>

0000000080004e2a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e2a:	7175                	addi	sp,sp,-144
    80004e2c:	e506                	sd	ra,136(sp)
    80004e2e:	e122                	sd	s0,128(sp)
    80004e30:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e32:	fffff097          	auipc	ra,0xfffff
    80004e36:	882080e7          	jalr	-1918(ra) # 800036b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e3a:	08000613          	li	a2,128
    80004e3e:	f7040593          	addi	a1,s0,-144
    80004e42:	4501                	li	a0,0
    80004e44:	ffffd097          	auipc	ra,0xffffd
    80004e48:	37a080e7          	jalr	890(ra) # 800021be <argstr>
    80004e4c:	02054963          	bltz	a0,80004e7e <sys_mkdir+0x54>
    80004e50:	4681                	li	a3,0
    80004e52:	4601                	li	a2,0
    80004e54:	4585                	li	a1,1
    80004e56:	f7040513          	addi	a0,s0,-144
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	7fc080e7          	jalr	2044(ra) # 80004656 <create>
    80004e62:	cd11                	beqz	a0,80004e7e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	0e6080e7          	jalr	230(ra) # 80002f4a <iunlockput>
  end_op();
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	8c6080e7          	jalr	-1850(ra) # 80003732 <end_op>
  return 0;
    80004e74:	4501                	li	a0,0
}
    80004e76:	60aa                	ld	ra,136(sp)
    80004e78:	640a                	ld	s0,128(sp)
    80004e7a:	6149                	addi	sp,sp,144
    80004e7c:	8082                	ret
    end_op();
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	8b4080e7          	jalr	-1868(ra) # 80003732 <end_op>
    return -1;
    80004e86:	557d                	li	a0,-1
    80004e88:	b7fd                	j	80004e76 <sys_mkdir+0x4c>

0000000080004e8a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e8a:	7135                	addi	sp,sp,-160
    80004e8c:	ed06                	sd	ra,152(sp)
    80004e8e:	e922                	sd	s0,144(sp)
    80004e90:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	822080e7          	jalr	-2014(ra) # 800036b4 <begin_op>
  argint(1, &major);
    80004e9a:	f6c40593          	addi	a1,s0,-148
    80004e9e:	4505                	li	a0,1
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	2de080e7          	jalr	734(ra) # 8000217e <argint>
  argint(2, &minor);
    80004ea8:	f6840593          	addi	a1,s0,-152
    80004eac:	4509                	li	a0,2
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	2d0080e7          	jalr	720(ra) # 8000217e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eb6:	08000613          	li	a2,128
    80004eba:	f7040593          	addi	a1,s0,-144
    80004ebe:	4501                	li	a0,0
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	2fe080e7          	jalr	766(ra) # 800021be <argstr>
    80004ec8:	02054b63          	bltz	a0,80004efe <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ecc:	f6841683          	lh	a3,-152(s0)
    80004ed0:	f6c41603          	lh	a2,-148(s0)
    80004ed4:	458d                	li	a1,3
    80004ed6:	f7040513          	addi	a0,s0,-144
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	77c080e7          	jalr	1916(ra) # 80004656 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ee2:	cd11                	beqz	a0,80004efe <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ee4:	ffffe097          	auipc	ra,0xffffe
    80004ee8:	066080e7          	jalr	102(ra) # 80002f4a <iunlockput>
  end_op();
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	846080e7          	jalr	-1978(ra) # 80003732 <end_op>
  return 0;
    80004ef4:	4501                	li	a0,0
}
    80004ef6:	60ea                	ld	ra,152(sp)
    80004ef8:	644a                	ld	s0,144(sp)
    80004efa:	610d                	addi	sp,sp,160
    80004efc:	8082                	ret
    end_op();
    80004efe:	fffff097          	auipc	ra,0xfffff
    80004f02:	834080e7          	jalr	-1996(ra) # 80003732 <end_op>
    return -1;
    80004f06:	557d                	li	a0,-1
    80004f08:	b7fd                	j	80004ef6 <sys_mknod+0x6c>

0000000080004f0a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f0a:	7135                	addi	sp,sp,-160
    80004f0c:	ed06                	sd	ra,152(sp)
    80004f0e:	e922                	sd	s0,144(sp)
    80004f10:	e526                	sd	s1,136(sp)
    80004f12:	e14a                	sd	s2,128(sp)
    80004f14:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f16:	ffffc097          	auipc	ra,0xffffc
    80004f1a:	094080e7          	jalr	148(ra) # 80000faa <myproc>
    80004f1e:	892a                	mv	s2,a0
  
  begin_op();
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	794080e7          	jalr	1940(ra) # 800036b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f28:	08000613          	li	a2,128
    80004f2c:	f6040593          	addi	a1,s0,-160
    80004f30:	4501                	li	a0,0
    80004f32:	ffffd097          	auipc	ra,0xffffd
    80004f36:	28c080e7          	jalr	652(ra) # 800021be <argstr>
    80004f3a:	04054b63          	bltz	a0,80004f90 <sys_chdir+0x86>
    80004f3e:	f6040513          	addi	a0,s0,-160
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	552080e7          	jalr	1362(ra) # 80003494 <namei>
    80004f4a:	84aa                	mv	s1,a0
    80004f4c:	c131                	beqz	a0,80004f90 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	d9a080e7          	jalr	-614(ra) # 80002ce8 <ilock>
  if(ip->type != T_DIR){
    80004f56:	04449703          	lh	a4,68(s1)
    80004f5a:	4785                	li	a5,1
    80004f5c:	04f71063          	bne	a4,a5,80004f9c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f60:	8526                	mv	a0,s1
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	e48080e7          	jalr	-440(ra) # 80002daa <iunlock>
  iput(p->cwd);
    80004f6a:	15093503          	ld	a0,336(s2)
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	f34080e7          	jalr	-204(ra) # 80002ea2 <iput>
  end_op();
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	7bc080e7          	jalr	1980(ra) # 80003732 <end_op>
  p->cwd = ip;
    80004f7e:	14993823          	sd	s1,336(s2)
  return 0;
    80004f82:	4501                	li	a0,0
}
    80004f84:	60ea                	ld	ra,152(sp)
    80004f86:	644a                	ld	s0,144(sp)
    80004f88:	64aa                	ld	s1,136(sp)
    80004f8a:	690a                	ld	s2,128(sp)
    80004f8c:	610d                	addi	sp,sp,160
    80004f8e:	8082                	ret
    end_op();
    80004f90:	ffffe097          	auipc	ra,0xffffe
    80004f94:	7a2080e7          	jalr	1954(ra) # 80003732 <end_op>
    return -1;
    80004f98:	557d                	li	a0,-1
    80004f9a:	b7ed                	j	80004f84 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f9c:	8526                	mv	a0,s1
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	fac080e7          	jalr	-84(ra) # 80002f4a <iunlockput>
    end_op();
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	78c080e7          	jalr	1932(ra) # 80003732 <end_op>
    return -1;
    80004fae:	557d                	li	a0,-1
    80004fb0:	bfd1                	j	80004f84 <sys_chdir+0x7a>

0000000080004fb2 <sys_exec>:

uint64
sys_exec(void)
{
    80004fb2:	7145                	addi	sp,sp,-464
    80004fb4:	e786                	sd	ra,456(sp)
    80004fb6:	e3a2                	sd	s0,448(sp)
    80004fb8:	ff26                	sd	s1,440(sp)
    80004fba:	fb4a                	sd	s2,432(sp)
    80004fbc:	f74e                	sd	s3,424(sp)
    80004fbe:	f352                	sd	s4,416(sp)
    80004fc0:	ef56                	sd	s5,408(sp)
    80004fc2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004fc4:	e3840593          	addi	a1,s0,-456
    80004fc8:	4505                	li	a0,1
    80004fca:	ffffd097          	auipc	ra,0xffffd
    80004fce:	1d4080e7          	jalr	468(ra) # 8000219e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004fd2:	08000613          	li	a2,128
    80004fd6:	f4040593          	addi	a1,s0,-192
    80004fda:	4501                	li	a0,0
    80004fdc:	ffffd097          	auipc	ra,0xffffd
    80004fe0:	1e2080e7          	jalr	482(ra) # 800021be <argstr>
    80004fe4:	87aa                	mv	a5,a0
    return -1;
    80004fe6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fe8:	0c07c363          	bltz	a5,800050ae <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004fec:	10000613          	li	a2,256
    80004ff0:	4581                	li	a1,0
    80004ff2:	e4040513          	addi	a0,s0,-448
    80004ff6:	ffffb097          	auipc	ra,0xffffb
    80004ffa:	202080e7          	jalr	514(ra) # 800001f8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ffe:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005002:	89a6                	mv	s3,s1
    80005004:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005006:	02000a13          	li	s4,32
    8000500a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000500e:	00391513          	slli	a0,s2,0x3
    80005012:	e3040593          	addi	a1,s0,-464
    80005016:	e3843783          	ld	a5,-456(s0)
    8000501a:	953e                	add	a0,a0,a5
    8000501c:	ffffd097          	auipc	ra,0xffffd
    80005020:	0c4080e7          	jalr	196(ra) # 800020e0 <fetchaddr>
    80005024:	02054a63          	bltz	a0,80005058 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005028:	e3043783          	ld	a5,-464(s0)
    8000502c:	c3b9                	beqz	a5,80005072 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000502e:	ffffb097          	auipc	ra,0xffffb
    80005032:	130080e7          	jalr	304(ra) # 8000015e <kalloc>
    80005036:	85aa                	mv	a1,a0
    80005038:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000503c:	cd11                	beqz	a0,80005058 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000503e:	6605                	lui	a2,0x1
    80005040:	e3043503          	ld	a0,-464(s0)
    80005044:	ffffd097          	auipc	ra,0xffffd
    80005048:	0ee080e7          	jalr	238(ra) # 80002132 <fetchstr>
    8000504c:	00054663          	bltz	a0,80005058 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005050:	0905                	addi	s2,s2,1
    80005052:	09a1                	addi	s3,s3,8
    80005054:	fb491be3          	bne	s2,s4,8000500a <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005058:	f4040913          	addi	s2,s0,-192
    8000505c:	6088                	ld	a0,0(s1)
    8000505e:	c539                	beqz	a0,800050ac <sys_exec+0xfa>
    kfree(argv[i]);
    80005060:	ffffb097          	auipc	ra,0xffffb
    80005064:	fbc080e7          	jalr	-68(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005068:	04a1                	addi	s1,s1,8
    8000506a:	ff2499e3          	bne	s1,s2,8000505c <sys_exec+0xaa>
  return -1;
    8000506e:	557d                	li	a0,-1
    80005070:	a83d                	j	800050ae <sys_exec+0xfc>
      argv[i] = 0;
    80005072:	0a8e                	slli	s5,s5,0x3
    80005074:	fc0a8793          	addi	a5,s5,-64
    80005078:	00878ab3          	add	s5,a5,s0
    8000507c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005080:	e4040593          	addi	a1,s0,-448
    80005084:	f4040513          	addi	a0,s0,-192
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	16e080e7          	jalr	366(ra) # 800041f6 <exec>
    80005090:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005092:	f4040993          	addi	s3,s0,-192
    80005096:	6088                	ld	a0,0(s1)
    80005098:	c901                	beqz	a0,800050a8 <sys_exec+0xf6>
    kfree(argv[i]);
    8000509a:	ffffb097          	auipc	ra,0xffffb
    8000509e:	f82080e7          	jalr	-126(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050a2:	04a1                	addi	s1,s1,8
    800050a4:	ff3499e3          	bne	s1,s3,80005096 <sys_exec+0xe4>
  return ret;
    800050a8:	854a                	mv	a0,s2
    800050aa:	a011                	j	800050ae <sys_exec+0xfc>
  return -1;
    800050ac:	557d                	li	a0,-1
}
    800050ae:	60be                	ld	ra,456(sp)
    800050b0:	641e                	ld	s0,448(sp)
    800050b2:	74fa                	ld	s1,440(sp)
    800050b4:	795a                	ld	s2,432(sp)
    800050b6:	79ba                	ld	s3,424(sp)
    800050b8:	7a1a                	ld	s4,416(sp)
    800050ba:	6afa                	ld	s5,408(sp)
    800050bc:	6179                	addi	sp,sp,464
    800050be:	8082                	ret

00000000800050c0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050c0:	7139                	addi	sp,sp,-64
    800050c2:	fc06                	sd	ra,56(sp)
    800050c4:	f822                	sd	s0,48(sp)
    800050c6:	f426                	sd	s1,40(sp)
    800050c8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050ca:	ffffc097          	auipc	ra,0xffffc
    800050ce:	ee0080e7          	jalr	-288(ra) # 80000faa <myproc>
    800050d2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050d4:	fd840593          	addi	a1,s0,-40
    800050d8:	4501                	li	a0,0
    800050da:	ffffd097          	auipc	ra,0xffffd
    800050de:	0c4080e7          	jalr	196(ra) # 8000219e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050e2:	fc840593          	addi	a1,s0,-56
    800050e6:	fd040513          	addi	a0,s0,-48
    800050ea:	fffff097          	auipc	ra,0xfffff
    800050ee:	dc2080e7          	jalr	-574(ra) # 80003eac <pipealloc>
    return -1;
    800050f2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050f4:	0c054463          	bltz	a0,800051bc <sys_pipe+0xfc>
  fd0 = -1;
    800050f8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050fc:	fd043503          	ld	a0,-48(s0)
    80005100:	fffff097          	auipc	ra,0xfffff
    80005104:	514080e7          	jalr	1300(ra) # 80004614 <fdalloc>
    80005108:	fca42223          	sw	a0,-60(s0)
    8000510c:	08054b63          	bltz	a0,800051a2 <sys_pipe+0xe2>
    80005110:	fc843503          	ld	a0,-56(s0)
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	500080e7          	jalr	1280(ra) # 80004614 <fdalloc>
    8000511c:	fca42023          	sw	a0,-64(s0)
    80005120:	06054863          	bltz	a0,80005190 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005124:	4691                	li	a3,4
    80005126:	fc440613          	addi	a2,s0,-60
    8000512a:	fd843583          	ld	a1,-40(s0)
    8000512e:	68a8                	ld	a0,80(s1)
    80005130:	ffffc097          	auipc	ra,0xffffc
    80005134:	aac080e7          	jalr	-1364(ra) # 80000bdc <copyout>
    80005138:	02054063          	bltz	a0,80005158 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000513c:	4691                	li	a3,4
    8000513e:	fc040613          	addi	a2,s0,-64
    80005142:	fd843583          	ld	a1,-40(s0)
    80005146:	0591                	addi	a1,a1,4
    80005148:	68a8                	ld	a0,80(s1)
    8000514a:	ffffc097          	auipc	ra,0xffffc
    8000514e:	a92080e7          	jalr	-1390(ra) # 80000bdc <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005152:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005154:	06055463          	bgez	a0,800051bc <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005158:	fc442783          	lw	a5,-60(s0)
    8000515c:	07e9                	addi	a5,a5,26
    8000515e:	078e                	slli	a5,a5,0x3
    80005160:	97a6                	add	a5,a5,s1
    80005162:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005166:	fc042783          	lw	a5,-64(s0)
    8000516a:	07e9                	addi	a5,a5,26
    8000516c:	078e                	slli	a5,a5,0x3
    8000516e:	94be                	add	s1,s1,a5
    80005170:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005174:	fd043503          	ld	a0,-48(s0)
    80005178:	fffff097          	auipc	ra,0xfffff
    8000517c:	a04080e7          	jalr	-1532(ra) # 80003b7c <fileclose>
    fileclose(wf);
    80005180:	fc843503          	ld	a0,-56(s0)
    80005184:	fffff097          	auipc	ra,0xfffff
    80005188:	9f8080e7          	jalr	-1544(ra) # 80003b7c <fileclose>
    return -1;
    8000518c:	57fd                	li	a5,-1
    8000518e:	a03d                	j	800051bc <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005190:	fc442783          	lw	a5,-60(s0)
    80005194:	0007c763          	bltz	a5,800051a2 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005198:	07e9                	addi	a5,a5,26
    8000519a:	078e                	slli	a5,a5,0x3
    8000519c:	97a6                	add	a5,a5,s1
    8000519e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800051a2:	fd043503          	ld	a0,-48(s0)
    800051a6:	fffff097          	auipc	ra,0xfffff
    800051aa:	9d6080e7          	jalr	-1578(ra) # 80003b7c <fileclose>
    fileclose(wf);
    800051ae:	fc843503          	ld	a0,-56(s0)
    800051b2:	fffff097          	auipc	ra,0xfffff
    800051b6:	9ca080e7          	jalr	-1590(ra) # 80003b7c <fileclose>
    return -1;
    800051ba:	57fd                	li	a5,-1
}
    800051bc:	853e                	mv	a0,a5
    800051be:	70e2                	ld	ra,56(sp)
    800051c0:	7442                	ld	s0,48(sp)
    800051c2:	74a2                	ld	s1,40(sp)
    800051c4:	6121                	addi	sp,sp,64
    800051c6:	8082                	ret
	...

00000000800051d0 <kernelvec>:
    800051d0:	7111                	addi	sp,sp,-256
    800051d2:	e006                	sd	ra,0(sp)
    800051d4:	e40a                	sd	sp,8(sp)
    800051d6:	e80e                	sd	gp,16(sp)
    800051d8:	ec12                	sd	tp,24(sp)
    800051da:	f016                	sd	t0,32(sp)
    800051dc:	f41a                	sd	t1,40(sp)
    800051de:	f81e                	sd	t2,48(sp)
    800051e0:	fc22                	sd	s0,56(sp)
    800051e2:	e0a6                	sd	s1,64(sp)
    800051e4:	e4aa                	sd	a0,72(sp)
    800051e6:	e8ae                	sd	a1,80(sp)
    800051e8:	ecb2                	sd	a2,88(sp)
    800051ea:	f0b6                	sd	a3,96(sp)
    800051ec:	f4ba                	sd	a4,104(sp)
    800051ee:	f8be                	sd	a5,112(sp)
    800051f0:	fcc2                	sd	a6,120(sp)
    800051f2:	e146                	sd	a7,128(sp)
    800051f4:	e54a                	sd	s2,136(sp)
    800051f6:	e94e                	sd	s3,144(sp)
    800051f8:	ed52                	sd	s4,152(sp)
    800051fa:	f156                	sd	s5,160(sp)
    800051fc:	f55a                	sd	s6,168(sp)
    800051fe:	f95e                	sd	s7,176(sp)
    80005200:	fd62                	sd	s8,184(sp)
    80005202:	e1e6                	sd	s9,192(sp)
    80005204:	e5ea                	sd	s10,200(sp)
    80005206:	e9ee                	sd	s11,208(sp)
    80005208:	edf2                	sd	t3,216(sp)
    8000520a:	f1f6                	sd	t4,224(sp)
    8000520c:	f5fa                	sd	t5,232(sp)
    8000520e:	f9fe                	sd	t6,240(sp)
    80005210:	d9dfc0ef          	jal	ra,80001fac <kerneltrap>
    80005214:	6082                	ld	ra,0(sp)
    80005216:	6122                	ld	sp,8(sp)
    80005218:	61c2                	ld	gp,16(sp)
    8000521a:	7282                	ld	t0,32(sp)
    8000521c:	7322                	ld	t1,40(sp)
    8000521e:	73c2                	ld	t2,48(sp)
    80005220:	7462                	ld	s0,56(sp)
    80005222:	6486                	ld	s1,64(sp)
    80005224:	6526                	ld	a0,72(sp)
    80005226:	65c6                	ld	a1,80(sp)
    80005228:	6666                	ld	a2,88(sp)
    8000522a:	7686                	ld	a3,96(sp)
    8000522c:	7726                	ld	a4,104(sp)
    8000522e:	77c6                	ld	a5,112(sp)
    80005230:	7866                	ld	a6,120(sp)
    80005232:	688a                	ld	a7,128(sp)
    80005234:	692a                	ld	s2,136(sp)
    80005236:	69ca                	ld	s3,144(sp)
    80005238:	6a6a                	ld	s4,152(sp)
    8000523a:	7a8a                	ld	s5,160(sp)
    8000523c:	7b2a                	ld	s6,168(sp)
    8000523e:	7bca                	ld	s7,176(sp)
    80005240:	7c6a                	ld	s8,184(sp)
    80005242:	6c8e                	ld	s9,192(sp)
    80005244:	6d2e                	ld	s10,200(sp)
    80005246:	6dce                	ld	s11,208(sp)
    80005248:	6e6e                	ld	t3,216(sp)
    8000524a:	7e8e                	ld	t4,224(sp)
    8000524c:	7f2e                	ld	t5,232(sp)
    8000524e:	7fce                	ld	t6,240(sp)
    80005250:	6111                	addi	sp,sp,256
    80005252:	10200073          	sret
    80005256:	00000013          	nop
    8000525a:	00000013          	nop
    8000525e:	0001                	nop

0000000080005260 <timervec>:
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	e10c                	sd	a1,0(a0)
    80005266:	e510                	sd	a2,8(a0)
    80005268:	e914                	sd	a3,16(a0)
    8000526a:	6d0c                	ld	a1,24(a0)
    8000526c:	7110                	ld	a2,32(a0)
    8000526e:	6194                	ld	a3,0(a1)
    80005270:	96b2                	add	a3,a3,a2
    80005272:	e194                	sd	a3,0(a1)
    80005274:	4589                	li	a1,2
    80005276:	14459073          	csrw	sip,a1
    8000527a:	6914                	ld	a3,16(a0)
    8000527c:	6510                	ld	a2,8(a0)
    8000527e:	610c                	ld	a1,0(a0)
    80005280:	34051573          	csrrw	a0,mscratch,a0
    80005284:	30200073          	mret
	...

000000008000528a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000528a:	1141                	addi	sp,sp,-16
    8000528c:	e422                	sd	s0,8(sp)
    8000528e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005290:	0c0007b7          	lui	a5,0xc000
    80005294:	4705                	li	a4,1
    80005296:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005298:	c3d8                	sw	a4,4(a5)
}
    8000529a:	6422                	ld	s0,8(sp)
    8000529c:	0141                	addi	sp,sp,16
    8000529e:	8082                	ret

00000000800052a0 <plicinithart>:

void
plicinithart(void)
{
    800052a0:	1141                	addi	sp,sp,-16
    800052a2:	e406                	sd	ra,8(sp)
    800052a4:	e022                	sd	s0,0(sp)
    800052a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	cd6080e7          	jalr	-810(ra) # 80000f7e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052b0:	0085171b          	slliw	a4,a0,0x8
    800052b4:	0c0027b7          	lui	a5,0xc002
    800052b8:	97ba                	add	a5,a5,a4
    800052ba:	40200713          	li	a4,1026
    800052be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052c2:	00d5151b          	slliw	a0,a0,0xd
    800052c6:	0c2017b7          	lui	a5,0xc201
    800052ca:	97aa                	add	a5,a5,a0
    800052cc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052d0:	60a2                	ld	ra,8(sp)
    800052d2:	6402                	ld	s0,0(sp)
    800052d4:	0141                	addi	sp,sp,16
    800052d6:	8082                	ret

00000000800052d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052d8:	1141                	addi	sp,sp,-16
    800052da:	e406                	sd	ra,8(sp)
    800052dc:	e022                	sd	s0,0(sp)
    800052de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e0:	ffffc097          	auipc	ra,0xffffc
    800052e4:	c9e080e7          	jalr	-866(ra) # 80000f7e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052e8:	00d5151b          	slliw	a0,a0,0xd
    800052ec:	0c2017b7          	lui	a5,0xc201
    800052f0:	97aa                	add	a5,a5,a0
  return irq;
}
    800052f2:	43c8                	lw	a0,4(a5)
    800052f4:	60a2                	ld	ra,8(sp)
    800052f6:	6402                	ld	s0,0(sp)
    800052f8:	0141                	addi	sp,sp,16
    800052fa:	8082                	ret

00000000800052fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052fc:	1101                	addi	sp,sp,-32
    800052fe:	ec06                	sd	ra,24(sp)
    80005300:	e822                	sd	s0,16(sp)
    80005302:	e426                	sd	s1,8(sp)
    80005304:	1000                	addi	s0,sp,32
    80005306:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	c76080e7          	jalr	-906(ra) # 80000f7e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005310:	00d5151b          	slliw	a0,a0,0xd
    80005314:	0c2017b7          	lui	a5,0xc201
    80005318:	97aa                	add	a5,a5,a0
    8000531a:	c3c4                	sw	s1,4(a5)
}
    8000531c:	60e2                	ld	ra,24(sp)
    8000531e:	6442                	ld	s0,16(sp)
    80005320:	64a2                	ld	s1,8(sp)
    80005322:	6105                	addi	sp,sp,32
    80005324:	8082                	ret

0000000080005326 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005326:	1141                	addi	sp,sp,-16
    80005328:	e406                	sd	ra,8(sp)
    8000532a:	e022                	sd	s0,0(sp)
    8000532c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000532e:	479d                	li	a5,7
    80005330:	04a7cc63          	blt	a5,a0,80005388 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005334:	00234797          	auipc	a5,0x234
    80005338:	6b478793          	addi	a5,a5,1716 # 802399e8 <disk>
    8000533c:	97aa                	add	a5,a5,a0
    8000533e:	0187c783          	lbu	a5,24(a5)
    80005342:	ebb9                	bnez	a5,80005398 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005344:	00451693          	slli	a3,a0,0x4
    80005348:	00234797          	auipc	a5,0x234
    8000534c:	6a078793          	addi	a5,a5,1696 # 802399e8 <disk>
    80005350:	6398                	ld	a4,0(a5)
    80005352:	9736                	add	a4,a4,a3
    80005354:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005358:	6398                	ld	a4,0(a5)
    8000535a:	9736                	add	a4,a4,a3
    8000535c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005360:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005364:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005368:	97aa                	add	a5,a5,a0
    8000536a:	4705                	li	a4,1
    8000536c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005370:	00234517          	auipc	a0,0x234
    80005374:	69050513          	addi	a0,a0,1680 # 80239a00 <disk+0x18>
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	33e080e7          	jalr	830(ra) # 800016b6 <wakeup>
}
    80005380:	60a2                	ld	ra,8(sp)
    80005382:	6402                	ld	s0,0(sp)
    80005384:	0141                	addi	sp,sp,16
    80005386:	8082                	ret
    panic("free_desc 1");
    80005388:	00003517          	auipc	a0,0x3
    8000538c:	33850513          	addi	a0,a0,824 # 800086c0 <syscalls+0x2f0>
    80005390:	00001097          	auipc	ra,0x1
    80005394:	a0c080e7          	jalr	-1524(ra) # 80005d9c <panic>
    panic("free_desc 2");
    80005398:	00003517          	auipc	a0,0x3
    8000539c:	33850513          	addi	a0,a0,824 # 800086d0 <syscalls+0x300>
    800053a0:	00001097          	auipc	ra,0x1
    800053a4:	9fc080e7          	jalr	-1540(ra) # 80005d9c <panic>

00000000800053a8 <virtio_disk_init>:
{
    800053a8:	1101                	addi	sp,sp,-32
    800053aa:	ec06                	sd	ra,24(sp)
    800053ac:	e822                	sd	s0,16(sp)
    800053ae:	e426                	sd	s1,8(sp)
    800053b0:	e04a                	sd	s2,0(sp)
    800053b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053b4:	00003597          	auipc	a1,0x3
    800053b8:	32c58593          	addi	a1,a1,812 # 800086e0 <syscalls+0x310>
    800053bc:	00234517          	auipc	a0,0x234
    800053c0:	75450513          	addi	a0,a0,1876 # 80239b10 <disk+0x128>
    800053c4:	00001097          	auipc	ra,0x1
    800053c8:	e80080e7          	jalr	-384(ra) # 80006244 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053cc:	100017b7          	lui	a5,0x10001
    800053d0:	4398                	lw	a4,0(a5)
    800053d2:	2701                	sext.w	a4,a4
    800053d4:	747277b7          	lui	a5,0x74727
    800053d8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053dc:	14f71b63          	bne	a4,a5,80005532 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053e0:	100017b7          	lui	a5,0x10001
    800053e4:	43dc                	lw	a5,4(a5)
    800053e6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e8:	4709                	li	a4,2
    800053ea:	14e79463          	bne	a5,a4,80005532 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ee:	100017b7          	lui	a5,0x10001
    800053f2:	479c                	lw	a5,8(a5)
    800053f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053f6:	12e79e63          	bne	a5,a4,80005532 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053fa:	100017b7          	lui	a5,0x10001
    800053fe:	47d8                	lw	a4,12(a5)
    80005400:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005402:	554d47b7          	lui	a5,0x554d4
    80005406:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000540a:	12f71463          	bne	a4,a5,80005532 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000540e:	100017b7          	lui	a5,0x10001
    80005412:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005416:	4705                	li	a4,1
    80005418:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000541a:	470d                	li	a4,3
    8000541c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000541e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005420:	c7ffe6b7          	lui	a3,0xc7ffe
    80005424:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc9ef>
    80005428:	8f75                	and	a4,a4,a3
    8000542a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542c:	472d                	li	a4,11
    8000542e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005430:	5bbc                	lw	a5,112(a5)
    80005432:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005436:	8ba1                	andi	a5,a5,8
    80005438:	10078563          	beqz	a5,80005542 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000543c:	100017b7          	lui	a5,0x10001
    80005440:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005444:	43fc                	lw	a5,68(a5)
    80005446:	2781                	sext.w	a5,a5
    80005448:	10079563          	bnez	a5,80005552 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000544c:	100017b7          	lui	a5,0x10001
    80005450:	5bdc                	lw	a5,52(a5)
    80005452:	2781                	sext.w	a5,a5
  if(max == 0)
    80005454:	10078763          	beqz	a5,80005562 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005458:	471d                	li	a4,7
    8000545a:	10f77c63          	bgeu	a4,a5,80005572 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000545e:	ffffb097          	auipc	ra,0xffffb
    80005462:	d00080e7          	jalr	-768(ra) # 8000015e <kalloc>
    80005466:	00234497          	auipc	s1,0x234
    8000546a:	58248493          	addi	s1,s1,1410 # 802399e8 <disk>
    8000546e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005470:	ffffb097          	auipc	ra,0xffffb
    80005474:	cee080e7          	jalr	-786(ra) # 8000015e <kalloc>
    80005478:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000547a:	ffffb097          	auipc	ra,0xffffb
    8000547e:	ce4080e7          	jalr	-796(ra) # 8000015e <kalloc>
    80005482:	87aa                	mv	a5,a0
    80005484:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005486:	6088                	ld	a0,0(s1)
    80005488:	cd6d                	beqz	a0,80005582 <virtio_disk_init+0x1da>
    8000548a:	00234717          	auipc	a4,0x234
    8000548e:	56673703          	ld	a4,1382(a4) # 802399f0 <disk+0x8>
    80005492:	cb65                	beqz	a4,80005582 <virtio_disk_init+0x1da>
    80005494:	c7fd                	beqz	a5,80005582 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005496:	6605                	lui	a2,0x1
    80005498:	4581                	li	a1,0
    8000549a:	ffffb097          	auipc	ra,0xffffb
    8000549e:	d5e080e7          	jalr	-674(ra) # 800001f8 <memset>
  memset(disk.avail, 0, PGSIZE);
    800054a2:	00234497          	auipc	s1,0x234
    800054a6:	54648493          	addi	s1,s1,1350 # 802399e8 <disk>
    800054aa:	6605                	lui	a2,0x1
    800054ac:	4581                	li	a1,0
    800054ae:	6488                	ld	a0,8(s1)
    800054b0:	ffffb097          	auipc	ra,0xffffb
    800054b4:	d48080e7          	jalr	-696(ra) # 800001f8 <memset>
  memset(disk.used, 0, PGSIZE);
    800054b8:	6605                	lui	a2,0x1
    800054ba:	4581                	li	a1,0
    800054bc:	6888                	ld	a0,16(s1)
    800054be:	ffffb097          	auipc	ra,0xffffb
    800054c2:	d3a080e7          	jalr	-710(ra) # 800001f8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054c6:	100017b7          	lui	a5,0x10001
    800054ca:	4721                	li	a4,8
    800054cc:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800054ce:	4098                	lw	a4,0(s1)
    800054d0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054d4:	40d8                	lw	a4,4(s1)
    800054d6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054da:	6498                	ld	a4,8(s1)
    800054dc:	0007069b          	sext.w	a3,a4
    800054e0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054e4:	9701                	srai	a4,a4,0x20
    800054e6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054ea:	6898                	ld	a4,16(s1)
    800054ec:	0007069b          	sext.w	a3,a4
    800054f0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054f4:	9701                	srai	a4,a4,0x20
    800054f6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054fa:	4705                	li	a4,1
    800054fc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800054fe:	00e48c23          	sb	a4,24(s1)
    80005502:	00e48ca3          	sb	a4,25(s1)
    80005506:	00e48d23          	sb	a4,26(s1)
    8000550a:	00e48da3          	sb	a4,27(s1)
    8000550e:	00e48e23          	sb	a4,28(s1)
    80005512:	00e48ea3          	sb	a4,29(s1)
    80005516:	00e48f23          	sb	a4,30(s1)
    8000551a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000551e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005522:	0727a823          	sw	s2,112(a5)
}
    80005526:	60e2                	ld	ra,24(sp)
    80005528:	6442                	ld	s0,16(sp)
    8000552a:	64a2                	ld	s1,8(sp)
    8000552c:	6902                	ld	s2,0(sp)
    8000552e:	6105                	addi	sp,sp,32
    80005530:	8082                	ret
    panic("could not find virtio disk");
    80005532:	00003517          	auipc	a0,0x3
    80005536:	1be50513          	addi	a0,a0,446 # 800086f0 <syscalls+0x320>
    8000553a:	00001097          	auipc	ra,0x1
    8000553e:	862080e7          	jalr	-1950(ra) # 80005d9c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	1ce50513          	addi	a0,a0,462 # 80008710 <syscalls+0x340>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	852080e7          	jalr	-1966(ra) # 80005d9c <panic>
    panic("virtio disk should not be ready");
    80005552:	00003517          	auipc	a0,0x3
    80005556:	1de50513          	addi	a0,a0,478 # 80008730 <syscalls+0x360>
    8000555a:	00001097          	auipc	ra,0x1
    8000555e:	842080e7          	jalr	-1982(ra) # 80005d9c <panic>
    panic("virtio disk has no queue 0");
    80005562:	00003517          	auipc	a0,0x3
    80005566:	1ee50513          	addi	a0,a0,494 # 80008750 <syscalls+0x380>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	832080e7          	jalr	-1998(ra) # 80005d9c <panic>
    panic("virtio disk max queue too short");
    80005572:	00003517          	auipc	a0,0x3
    80005576:	1fe50513          	addi	a0,a0,510 # 80008770 <syscalls+0x3a0>
    8000557a:	00001097          	auipc	ra,0x1
    8000557e:	822080e7          	jalr	-2014(ra) # 80005d9c <panic>
    panic("virtio disk kalloc");
    80005582:	00003517          	auipc	a0,0x3
    80005586:	20e50513          	addi	a0,a0,526 # 80008790 <syscalls+0x3c0>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	812080e7          	jalr	-2030(ra) # 80005d9c <panic>

0000000080005592 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005592:	7119                	addi	sp,sp,-128
    80005594:	fc86                	sd	ra,120(sp)
    80005596:	f8a2                	sd	s0,112(sp)
    80005598:	f4a6                	sd	s1,104(sp)
    8000559a:	f0ca                	sd	s2,96(sp)
    8000559c:	ecce                	sd	s3,88(sp)
    8000559e:	e8d2                	sd	s4,80(sp)
    800055a0:	e4d6                	sd	s5,72(sp)
    800055a2:	e0da                	sd	s6,64(sp)
    800055a4:	fc5e                	sd	s7,56(sp)
    800055a6:	f862                	sd	s8,48(sp)
    800055a8:	f466                	sd	s9,40(sp)
    800055aa:	f06a                	sd	s10,32(sp)
    800055ac:	ec6e                	sd	s11,24(sp)
    800055ae:	0100                	addi	s0,sp,128
    800055b0:	8aaa                	mv	s5,a0
    800055b2:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055b4:	00c52d03          	lw	s10,12(a0)
    800055b8:	001d1d1b          	slliw	s10,s10,0x1
    800055bc:	1d02                	slli	s10,s10,0x20
    800055be:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800055c2:	00234517          	auipc	a0,0x234
    800055c6:	54e50513          	addi	a0,a0,1358 # 80239b10 <disk+0x128>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	d0a080e7          	jalr	-758(ra) # 800062d4 <acquire>
  for(int i = 0; i < 3; i++){
    800055d2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055d4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055d6:	00234b97          	auipc	s7,0x234
    800055da:	412b8b93          	addi	s7,s7,1042 # 802399e8 <disk>
  for(int i = 0; i < 3; i++){
    800055de:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055e0:	00234c97          	auipc	s9,0x234
    800055e4:	530c8c93          	addi	s9,s9,1328 # 80239b10 <disk+0x128>
    800055e8:	a08d                	j	8000564a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800055ea:	00fb8733          	add	a4,s7,a5
    800055ee:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055f2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055f4:	0207c563          	bltz	a5,8000561e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800055f8:	2905                	addiw	s2,s2,1
    800055fa:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800055fc:	05690c63          	beq	s2,s6,80005654 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005600:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005602:	00234717          	auipc	a4,0x234
    80005606:	3e670713          	addi	a4,a4,998 # 802399e8 <disk>
    8000560a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000560c:	01874683          	lbu	a3,24(a4)
    80005610:	fee9                	bnez	a3,800055ea <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005612:	2785                	addiw	a5,a5,1
    80005614:	0705                	addi	a4,a4,1
    80005616:	fe979be3          	bne	a5,s1,8000560c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000561a:	57fd                	li	a5,-1
    8000561c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000561e:	01205d63          	blez	s2,80005638 <virtio_disk_rw+0xa6>
    80005622:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005624:	000a2503          	lw	a0,0(s4)
    80005628:	00000097          	auipc	ra,0x0
    8000562c:	cfe080e7          	jalr	-770(ra) # 80005326 <free_desc>
      for(int j = 0; j < i; j++)
    80005630:	2d85                	addiw	s11,s11,1
    80005632:	0a11                	addi	s4,s4,4
    80005634:	ff2d98e3          	bne	s11,s2,80005624 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005638:	85e6                	mv	a1,s9
    8000563a:	00234517          	auipc	a0,0x234
    8000563e:	3c650513          	addi	a0,a0,966 # 80239a00 <disk+0x18>
    80005642:	ffffc097          	auipc	ra,0xffffc
    80005646:	010080e7          	jalr	16(ra) # 80001652 <sleep>
  for(int i = 0; i < 3; i++){
    8000564a:	f8040a13          	addi	s4,s0,-128
{
    8000564e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005650:	894e                	mv	s2,s3
    80005652:	b77d                	j	80005600 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005654:	f8042503          	lw	a0,-128(s0)
    80005658:	00a50713          	addi	a4,a0,10
    8000565c:	0712                	slli	a4,a4,0x4

  if(write)
    8000565e:	00234797          	auipc	a5,0x234
    80005662:	38a78793          	addi	a5,a5,906 # 802399e8 <disk>
    80005666:	00e786b3          	add	a3,a5,a4
    8000566a:	01803633          	snez	a2,s8
    8000566e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005670:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005674:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005678:	f6070613          	addi	a2,a4,-160
    8000567c:	6394                	ld	a3,0(a5)
    8000567e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005680:	00870593          	addi	a1,a4,8
    80005684:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005686:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005688:	0007b803          	ld	a6,0(a5)
    8000568c:	9642                	add	a2,a2,a6
    8000568e:	46c1                	li	a3,16
    80005690:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005692:	4585                	li	a1,1
    80005694:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005698:	f8442683          	lw	a3,-124(s0)
    8000569c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056a0:	0692                	slli	a3,a3,0x4
    800056a2:	9836                	add	a6,a6,a3
    800056a4:	058a8613          	addi	a2,s5,88
    800056a8:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    800056ac:	0007b803          	ld	a6,0(a5)
    800056b0:	96c2                	add	a3,a3,a6
    800056b2:	40000613          	li	a2,1024
    800056b6:	c690                	sw	a2,8(a3)
  if(write)
    800056b8:	001c3613          	seqz	a2,s8
    800056bc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056c0:	00166613          	ori	a2,a2,1
    800056c4:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056c8:	f8842603          	lw	a2,-120(s0)
    800056cc:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056d0:	00250693          	addi	a3,a0,2
    800056d4:	0692                	slli	a3,a3,0x4
    800056d6:	96be                	add	a3,a3,a5
    800056d8:	58fd                	li	a7,-1
    800056da:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056de:	0612                	slli	a2,a2,0x4
    800056e0:	9832                	add	a6,a6,a2
    800056e2:	f9070713          	addi	a4,a4,-112
    800056e6:	973e                	add	a4,a4,a5
    800056e8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800056ec:	6398                	ld	a4,0(a5)
    800056ee:	9732                	add	a4,a4,a2
    800056f0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056f2:	4609                	li	a2,2
    800056f4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800056f8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056fc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005700:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005704:	6794                	ld	a3,8(a5)
    80005706:	0026d703          	lhu	a4,2(a3)
    8000570a:	8b1d                	andi	a4,a4,7
    8000570c:	0706                	slli	a4,a4,0x1
    8000570e:	96ba                	add	a3,a3,a4
    80005710:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005714:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005718:	6798                	ld	a4,8(a5)
    8000571a:	00275783          	lhu	a5,2(a4)
    8000571e:	2785                	addiw	a5,a5,1
    80005720:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005724:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005728:	100017b7          	lui	a5,0x10001
    8000572c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005730:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005734:	00234917          	auipc	s2,0x234
    80005738:	3dc90913          	addi	s2,s2,988 # 80239b10 <disk+0x128>
  while(b->disk == 1) {
    8000573c:	4485                	li	s1,1
    8000573e:	00b79c63          	bne	a5,a1,80005756 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005742:	85ca                	mv	a1,s2
    80005744:	8556                	mv	a0,s5
    80005746:	ffffc097          	auipc	ra,0xffffc
    8000574a:	f0c080e7          	jalr	-244(ra) # 80001652 <sleep>
  while(b->disk == 1) {
    8000574e:	004aa783          	lw	a5,4(s5)
    80005752:	fe9788e3          	beq	a5,s1,80005742 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005756:	f8042903          	lw	s2,-128(s0)
    8000575a:	00290713          	addi	a4,s2,2
    8000575e:	0712                	slli	a4,a4,0x4
    80005760:	00234797          	auipc	a5,0x234
    80005764:	28878793          	addi	a5,a5,648 # 802399e8 <disk>
    80005768:	97ba                	add	a5,a5,a4
    8000576a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000576e:	00234997          	auipc	s3,0x234
    80005772:	27a98993          	addi	s3,s3,634 # 802399e8 <disk>
    80005776:	00491713          	slli	a4,s2,0x4
    8000577a:	0009b783          	ld	a5,0(s3)
    8000577e:	97ba                	add	a5,a5,a4
    80005780:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005784:	854a                	mv	a0,s2
    80005786:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000578a:	00000097          	auipc	ra,0x0
    8000578e:	b9c080e7          	jalr	-1124(ra) # 80005326 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005792:	8885                	andi	s1,s1,1
    80005794:	f0ed                	bnez	s1,80005776 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005796:	00234517          	auipc	a0,0x234
    8000579a:	37a50513          	addi	a0,a0,890 # 80239b10 <disk+0x128>
    8000579e:	00001097          	auipc	ra,0x1
    800057a2:	bea080e7          	jalr	-1046(ra) # 80006388 <release>
}
    800057a6:	70e6                	ld	ra,120(sp)
    800057a8:	7446                	ld	s0,112(sp)
    800057aa:	74a6                	ld	s1,104(sp)
    800057ac:	7906                	ld	s2,96(sp)
    800057ae:	69e6                	ld	s3,88(sp)
    800057b0:	6a46                	ld	s4,80(sp)
    800057b2:	6aa6                	ld	s5,72(sp)
    800057b4:	6b06                	ld	s6,64(sp)
    800057b6:	7be2                	ld	s7,56(sp)
    800057b8:	7c42                	ld	s8,48(sp)
    800057ba:	7ca2                	ld	s9,40(sp)
    800057bc:	7d02                	ld	s10,32(sp)
    800057be:	6de2                	ld	s11,24(sp)
    800057c0:	6109                	addi	sp,sp,128
    800057c2:	8082                	ret

00000000800057c4 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057c4:	1101                	addi	sp,sp,-32
    800057c6:	ec06                	sd	ra,24(sp)
    800057c8:	e822                	sd	s0,16(sp)
    800057ca:	e426                	sd	s1,8(sp)
    800057cc:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057ce:	00234497          	auipc	s1,0x234
    800057d2:	21a48493          	addi	s1,s1,538 # 802399e8 <disk>
    800057d6:	00234517          	auipc	a0,0x234
    800057da:	33a50513          	addi	a0,a0,826 # 80239b10 <disk+0x128>
    800057de:	00001097          	auipc	ra,0x1
    800057e2:	af6080e7          	jalr	-1290(ra) # 800062d4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057e6:	10001737          	lui	a4,0x10001
    800057ea:	533c                	lw	a5,96(a4)
    800057ec:	8b8d                	andi	a5,a5,3
    800057ee:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057f0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057f4:	689c                	ld	a5,16(s1)
    800057f6:	0204d703          	lhu	a4,32(s1)
    800057fa:	0027d783          	lhu	a5,2(a5)
    800057fe:	04f70863          	beq	a4,a5,8000584e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005802:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005806:	6898                	ld	a4,16(s1)
    80005808:	0204d783          	lhu	a5,32(s1)
    8000580c:	8b9d                	andi	a5,a5,7
    8000580e:	078e                	slli	a5,a5,0x3
    80005810:	97ba                	add	a5,a5,a4
    80005812:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005814:	00278713          	addi	a4,a5,2
    80005818:	0712                	slli	a4,a4,0x4
    8000581a:	9726                	add	a4,a4,s1
    8000581c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005820:	e721                	bnez	a4,80005868 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005822:	0789                	addi	a5,a5,2
    80005824:	0792                	slli	a5,a5,0x4
    80005826:	97a6                	add	a5,a5,s1
    80005828:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000582a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000582e:	ffffc097          	auipc	ra,0xffffc
    80005832:	e88080e7          	jalr	-376(ra) # 800016b6 <wakeup>

    disk.used_idx += 1;
    80005836:	0204d783          	lhu	a5,32(s1)
    8000583a:	2785                	addiw	a5,a5,1
    8000583c:	17c2                	slli	a5,a5,0x30
    8000583e:	93c1                	srli	a5,a5,0x30
    80005840:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005844:	6898                	ld	a4,16(s1)
    80005846:	00275703          	lhu	a4,2(a4)
    8000584a:	faf71ce3          	bne	a4,a5,80005802 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000584e:	00234517          	auipc	a0,0x234
    80005852:	2c250513          	addi	a0,a0,706 # 80239b10 <disk+0x128>
    80005856:	00001097          	auipc	ra,0x1
    8000585a:	b32080e7          	jalr	-1230(ra) # 80006388 <release>
}
    8000585e:	60e2                	ld	ra,24(sp)
    80005860:	6442                	ld	s0,16(sp)
    80005862:	64a2                	ld	s1,8(sp)
    80005864:	6105                	addi	sp,sp,32
    80005866:	8082                	ret
      panic("virtio_disk_intr status");
    80005868:	00003517          	auipc	a0,0x3
    8000586c:	f4050513          	addi	a0,a0,-192 # 800087a8 <syscalls+0x3d8>
    80005870:	00000097          	auipc	ra,0x0
    80005874:	52c080e7          	jalr	1324(ra) # 80005d9c <panic>

0000000080005878 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005878:	1141                	addi	sp,sp,-16
    8000587a:	e422                	sd	s0,8(sp)
    8000587c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000587e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005882:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005886:	0037979b          	slliw	a5,a5,0x3
    8000588a:	02004737          	lui	a4,0x2004
    8000588e:	97ba                	add	a5,a5,a4
    80005890:	0200c737          	lui	a4,0x200c
    80005894:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005898:	000f4637          	lui	a2,0xf4
    8000589c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058a0:	9732                	add	a4,a4,a2
    800058a2:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058a4:	00259693          	slli	a3,a1,0x2
    800058a8:	96ae                	add	a3,a3,a1
    800058aa:	068e                	slli	a3,a3,0x3
    800058ac:	00234717          	auipc	a4,0x234
    800058b0:	28470713          	addi	a4,a4,644 # 80239b30 <timer_scratch>
    800058b4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058b6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058b8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ba:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058be:	00000797          	auipc	a5,0x0
    800058c2:	9a278793          	addi	a5,a5,-1630 # 80005260 <timervec>
    800058c6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058ca:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058ce:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058d6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058da:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058de:	30479073          	csrw	mie,a5
}
    800058e2:	6422                	ld	s0,8(sp)
    800058e4:	0141                	addi	sp,sp,16
    800058e6:	8082                	ret

00000000800058e8 <start>:
{
    800058e8:	1141                	addi	sp,sp,-16
    800058ea:	e406                	sd	ra,8(sp)
    800058ec:	e022                	sd	s0,0(sp)
    800058ee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058f0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058f4:	7779                	lui	a4,0xffffe
    800058f6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbca8f>
    800058fa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058fc:	6705                	lui	a4,0x1
    800058fe:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005902:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005904:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005908:	ffffb797          	auipc	a5,0xffffb
    8000590c:	a9678793          	addi	a5,a5,-1386 # 8000039e <main>
    80005910:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005914:	4781                	li	a5,0
    80005916:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000591a:	67c1                	lui	a5,0x10
    8000591c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000591e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005922:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005926:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000592a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000592e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005932:	57fd                	li	a5,-1
    80005934:	83a9                	srli	a5,a5,0xa
    80005936:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000593a:	47bd                	li	a5,15
    8000593c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005940:	00000097          	auipc	ra,0x0
    80005944:	f38080e7          	jalr	-200(ra) # 80005878 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005948:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000594c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000594e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005950:	30200073          	mret
}
    80005954:	60a2                	ld	ra,8(sp)
    80005956:	6402                	ld	s0,0(sp)
    80005958:	0141                	addi	sp,sp,16
    8000595a:	8082                	ret

000000008000595c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000595c:	715d                	addi	sp,sp,-80
    8000595e:	e486                	sd	ra,72(sp)
    80005960:	e0a2                	sd	s0,64(sp)
    80005962:	fc26                	sd	s1,56(sp)
    80005964:	f84a                	sd	s2,48(sp)
    80005966:	f44e                	sd	s3,40(sp)
    80005968:	f052                	sd	s4,32(sp)
    8000596a:	ec56                	sd	s5,24(sp)
    8000596c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000596e:	04c05763          	blez	a2,800059bc <consolewrite+0x60>
    80005972:	8a2a                	mv	s4,a0
    80005974:	84ae                	mv	s1,a1
    80005976:	89b2                	mv	s3,a2
    80005978:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000597a:	5afd                	li	s5,-1
    8000597c:	4685                	li	a3,1
    8000597e:	8626                	mv	a2,s1
    80005980:	85d2                	mv	a1,s4
    80005982:	fbf40513          	addi	a0,s0,-65
    80005986:	ffffc097          	auipc	ra,0xffffc
    8000598a:	12a080e7          	jalr	298(ra) # 80001ab0 <either_copyin>
    8000598e:	01550d63          	beq	a0,s5,800059a8 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005992:	fbf44503          	lbu	a0,-65(s0)
    80005996:	00000097          	auipc	ra,0x0
    8000599a:	784080e7          	jalr	1924(ra) # 8000611a <uartputc>
  for(i = 0; i < n; i++){
    8000599e:	2905                	addiw	s2,s2,1
    800059a0:	0485                	addi	s1,s1,1
    800059a2:	fd299de3          	bne	s3,s2,8000597c <consolewrite+0x20>
    800059a6:	894e                	mv	s2,s3
  }

  return i;
}
    800059a8:	854a                	mv	a0,s2
    800059aa:	60a6                	ld	ra,72(sp)
    800059ac:	6406                	ld	s0,64(sp)
    800059ae:	74e2                	ld	s1,56(sp)
    800059b0:	7942                	ld	s2,48(sp)
    800059b2:	79a2                	ld	s3,40(sp)
    800059b4:	7a02                	ld	s4,32(sp)
    800059b6:	6ae2                	ld	s5,24(sp)
    800059b8:	6161                	addi	sp,sp,80
    800059ba:	8082                	ret
  for(i = 0; i < n; i++){
    800059bc:	4901                	li	s2,0
    800059be:	b7ed                	j	800059a8 <consolewrite+0x4c>

00000000800059c0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059c0:	7159                	addi	sp,sp,-112
    800059c2:	f486                	sd	ra,104(sp)
    800059c4:	f0a2                	sd	s0,96(sp)
    800059c6:	eca6                	sd	s1,88(sp)
    800059c8:	e8ca                	sd	s2,80(sp)
    800059ca:	e4ce                	sd	s3,72(sp)
    800059cc:	e0d2                	sd	s4,64(sp)
    800059ce:	fc56                	sd	s5,56(sp)
    800059d0:	f85a                	sd	s6,48(sp)
    800059d2:	f45e                	sd	s7,40(sp)
    800059d4:	f062                	sd	s8,32(sp)
    800059d6:	ec66                	sd	s9,24(sp)
    800059d8:	e86a                	sd	s10,16(sp)
    800059da:	1880                	addi	s0,sp,112
    800059dc:	8aaa                	mv	s5,a0
    800059de:	8a2e                	mv	s4,a1
    800059e0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059e2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059e6:	0023c517          	auipc	a0,0x23c
    800059ea:	28a50513          	addi	a0,a0,650 # 80241c70 <cons>
    800059ee:	00001097          	auipc	ra,0x1
    800059f2:	8e6080e7          	jalr	-1818(ra) # 800062d4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059f6:	0023c497          	auipc	s1,0x23c
    800059fa:	27a48493          	addi	s1,s1,634 # 80241c70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059fe:	0023c917          	auipc	s2,0x23c
    80005a02:	30a90913          	addi	s2,s2,778 # 80241d08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005a06:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a08:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a0a:	4ca9                	li	s9,10
  while(n > 0){
    80005a0c:	07305b63          	blez	s3,80005a82 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005a10:	0984a783          	lw	a5,152(s1)
    80005a14:	09c4a703          	lw	a4,156(s1)
    80005a18:	02f71763          	bne	a4,a5,80005a46 <consoleread+0x86>
      if(killed(myproc())){
    80005a1c:	ffffb097          	auipc	ra,0xffffb
    80005a20:	58e080e7          	jalr	1422(ra) # 80000faa <myproc>
    80005a24:	ffffc097          	auipc	ra,0xffffc
    80005a28:	ed6080e7          	jalr	-298(ra) # 800018fa <killed>
    80005a2c:	e535                	bnez	a0,80005a98 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005a2e:	85a6                	mv	a1,s1
    80005a30:	854a                	mv	a0,s2
    80005a32:	ffffc097          	auipc	ra,0xffffc
    80005a36:	c20080e7          	jalr	-992(ra) # 80001652 <sleep>
    while(cons.r == cons.w){
    80005a3a:	0984a783          	lw	a5,152(s1)
    80005a3e:	09c4a703          	lw	a4,156(s1)
    80005a42:	fcf70de3          	beq	a4,a5,80005a1c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a46:	0017871b          	addiw	a4,a5,1
    80005a4a:	08e4ac23          	sw	a4,152(s1)
    80005a4e:	07f7f713          	andi	a4,a5,127
    80005a52:	9726                	add	a4,a4,s1
    80005a54:	01874703          	lbu	a4,24(a4)
    80005a58:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a5c:	077d0563          	beq	s10,s7,80005ac6 <consoleread+0x106>
    cbuf = c;
    80005a60:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a64:	4685                	li	a3,1
    80005a66:	f9f40613          	addi	a2,s0,-97
    80005a6a:	85d2                	mv	a1,s4
    80005a6c:	8556                	mv	a0,s5
    80005a6e:	ffffc097          	auipc	ra,0xffffc
    80005a72:	fec080e7          	jalr	-20(ra) # 80001a5a <either_copyout>
    80005a76:	01850663          	beq	a0,s8,80005a82 <consoleread+0xc2>
    dst++;
    80005a7a:	0a05                	addi	s4,s4,1
    --n;
    80005a7c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a7e:	f99d17e3          	bne	s10,s9,80005a0c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a82:	0023c517          	auipc	a0,0x23c
    80005a86:	1ee50513          	addi	a0,a0,494 # 80241c70 <cons>
    80005a8a:	00001097          	auipc	ra,0x1
    80005a8e:	8fe080e7          	jalr	-1794(ra) # 80006388 <release>

  return target - n;
    80005a92:	413b053b          	subw	a0,s6,s3
    80005a96:	a811                	j	80005aaa <consoleread+0xea>
        release(&cons.lock);
    80005a98:	0023c517          	auipc	a0,0x23c
    80005a9c:	1d850513          	addi	a0,a0,472 # 80241c70 <cons>
    80005aa0:	00001097          	auipc	ra,0x1
    80005aa4:	8e8080e7          	jalr	-1816(ra) # 80006388 <release>
        return -1;
    80005aa8:	557d                	li	a0,-1
}
    80005aaa:	70a6                	ld	ra,104(sp)
    80005aac:	7406                	ld	s0,96(sp)
    80005aae:	64e6                	ld	s1,88(sp)
    80005ab0:	6946                	ld	s2,80(sp)
    80005ab2:	69a6                	ld	s3,72(sp)
    80005ab4:	6a06                	ld	s4,64(sp)
    80005ab6:	7ae2                	ld	s5,56(sp)
    80005ab8:	7b42                	ld	s6,48(sp)
    80005aba:	7ba2                	ld	s7,40(sp)
    80005abc:	7c02                	ld	s8,32(sp)
    80005abe:	6ce2                	ld	s9,24(sp)
    80005ac0:	6d42                	ld	s10,16(sp)
    80005ac2:	6165                	addi	sp,sp,112
    80005ac4:	8082                	ret
      if(n < target){
    80005ac6:	0009871b          	sext.w	a4,s3
    80005aca:	fb677ce3          	bgeu	a4,s6,80005a82 <consoleread+0xc2>
        cons.r--;
    80005ace:	0023c717          	auipc	a4,0x23c
    80005ad2:	22f72d23          	sw	a5,570(a4) # 80241d08 <cons+0x98>
    80005ad6:	b775                	j	80005a82 <consoleread+0xc2>

0000000080005ad8 <consputc>:
{
    80005ad8:	1141                	addi	sp,sp,-16
    80005ada:	e406                	sd	ra,8(sp)
    80005adc:	e022                	sd	s0,0(sp)
    80005ade:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ae0:	10000793          	li	a5,256
    80005ae4:	00f50a63          	beq	a0,a5,80005af8 <consputc+0x20>
    uartputc_sync(c);
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	560080e7          	jalr	1376(ra) # 80006048 <uartputc_sync>
}
    80005af0:	60a2                	ld	ra,8(sp)
    80005af2:	6402                	ld	s0,0(sp)
    80005af4:	0141                	addi	sp,sp,16
    80005af6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005af8:	4521                	li	a0,8
    80005afa:	00000097          	auipc	ra,0x0
    80005afe:	54e080e7          	jalr	1358(ra) # 80006048 <uartputc_sync>
    80005b02:	02000513          	li	a0,32
    80005b06:	00000097          	auipc	ra,0x0
    80005b0a:	542080e7          	jalr	1346(ra) # 80006048 <uartputc_sync>
    80005b0e:	4521                	li	a0,8
    80005b10:	00000097          	auipc	ra,0x0
    80005b14:	538080e7          	jalr	1336(ra) # 80006048 <uartputc_sync>
    80005b18:	bfe1                	j	80005af0 <consputc+0x18>

0000000080005b1a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b1a:	1101                	addi	sp,sp,-32
    80005b1c:	ec06                	sd	ra,24(sp)
    80005b1e:	e822                	sd	s0,16(sp)
    80005b20:	e426                	sd	s1,8(sp)
    80005b22:	e04a                	sd	s2,0(sp)
    80005b24:	1000                	addi	s0,sp,32
    80005b26:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b28:	0023c517          	auipc	a0,0x23c
    80005b2c:	14850513          	addi	a0,a0,328 # 80241c70 <cons>
    80005b30:	00000097          	auipc	ra,0x0
    80005b34:	7a4080e7          	jalr	1956(ra) # 800062d4 <acquire>

  switch(c){
    80005b38:	47d5                	li	a5,21
    80005b3a:	0af48663          	beq	s1,a5,80005be6 <consoleintr+0xcc>
    80005b3e:	0297ca63          	blt	a5,s1,80005b72 <consoleintr+0x58>
    80005b42:	47a1                	li	a5,8
    80005b44:	0ef48763          	beq	s1,a5,80005c32 <consoleintr+0x118>
    80005b48:	47c1                	li	a5,16
    80005b4a:	10f49a63          	bne	s1,a5,80005c5e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b4e:	ffffc097          	auipc	ra,0xffffc
    80005b52:	fb8080e7          	jalr	-72(ra) # 80001b06 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b56:	0023c517          	auipc	a0,0x23c
    80005b5a:	11a50513          	addi	a0,a0,282 # 80241c70 <cons>
    80005b5e:	00001097          	auipc	ra,0x1
    80005b62:	82a080e7          	jalr	-2006(ra) # 80006388 <release>
}
    80005b66:	60e2                	ld	ra,24(sp)
    80005b68:	6442                	ld	s0,16(sp)
    80005b6a:	64a2                	ld	s1,8(sp)
    80005b6c:	6902                	ld	s2,0(sp)
    80005b6e:	6105                	addi	sp,sp,32
    80005b70:	8082                	ret
  switch(c){
    80005b72:	07f00793          	li	a5,127
    80005b76:	0af48e63          	beq	s1,a5,80005c32 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b7a:	0023c717          	auipc	a4,0x23c
    80005b7e:	0f670713          	addi	a4,a4,246 # 80241c70 <cons>
    80005b82:	0a072783          	lw	a5,160(a4)
    80005b86:	09872703          	lw	a4,152(a4)
    80005b8a:	9f99                	subw	a5,a5,a4
    80005b8c:	07f00713          	li	a4,127
    80005b90:	fcf763e3          	bltu	a4,a5,80005b56 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b94:	47b5                	li	a5,13
    80005b96:	0cf48763          	beq	s1,a5,80005c64 <consoleintr+0x14a>
      consputc(c);
    80005b9a:	8526                	mv	a0,s1
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	f3c080e7          	jalr	-196(ra) # 80005ad8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ba4:	0023c797          	auipc	a5,0x23c
    80005ba8:	0cc78793          	addi	a5,a5,204 # 80241c70 <cons>
    80005bac:	0a07a683          	lw	a3,160(a5)
    80005bb0:	0016871b          	addiw	a4,a3,1
    80005bb4:	0007061b          	sext.w	a2,a4
    80005bb8:	0ae7a023          	sw	a4,160(a5)
    80005bbc:	07f6f693          	andi	a3,a3,127
    80005bc0:	97b6                	add	a5,a5,a3
    80005bc2:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005bc6:	47a9                	li	a5,10
    80005bc8:	0cf48563          	beq	s1,a5,80005c92 <consoleintr+0x178>
    80005bcc:	4791                	li	a5,4
    80005bce:	0cf48263          	beq	s1,a5,80005c92 <consoleintr+0x178>
    80005bd2:	0023c797          	auipc	a5,0x23c
    80005bd6:	1367a783          	lw	a5,310(a5) # 80241d08 <cons+0x98>
    80005bda:	9f1d                	subw	a4,a4,a5
    80005bdc:	08000793          	li	a5,128
    80005be0:	f6f71be3          	bne	a4,a5,80005b56 <consoleintr+0x3c>
    80005be4:	a07d                	j	80005c92 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005be6:	0023c717          	auipc	a4,0x23c
    80005bea:	08a70713          	addi	a4,a4,138 # 80241c70 <cons>
    80005bee:	0a072783          	lw	a5,160(a4)
    80005bf2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bf6:	0023c497          	auipc	s1,0x23c
    80005bfa:	07a48493          	addi	s1,s1,122 # 80241c70 <cons>
    while(cons.e != cons.w &&
    80005bfe:	4929                	li	s2,10
    80005c00:	f4f70be3          	beq	a4,a5,80005b56 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c04:	37fd                	addiw	a5,a5,-1
    80005c06:	07f7f713          	andi	a4,a5,127
    80005c0a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c0c:	01874703          	lbu	a4,24(a4)
    80005c10:	f52703e3          	beq	a4,s2,80005b56 <consoleintr+0x3c>
      cons.e--;
    80005c14:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c18:	10000513          	li	a0,256
    80005c1c:	00000097          	auipc	ra,0x0
    80005c20:	ebc080e7          	jalr	-324(ra) # 80005ad8 <consputc>
    while(cons.e != cons.w &&
    80005c24:	0a04a783          	lw	a5,160(s1)
    80005c28:	09c4a703          	lw	a4,156(s1)
    80005c2c:	fcf71ce3          	bne	a4,a5,80005c04 <consoleintr+0xea>
    80005c30:	b71d                	j	80005b56 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c32:	0023c717          	auipc	a4,0x23c
    80005c36:	03e70713          	addi	a4,a4,62 # 80241c70 <cons>
    80005c3a:	0a072783          	lw	a5,160(a4)
    80005c3e:	09c72703          	lw	a4,156(a4)
    80005c42:	f0f70ae3          	beq	a4,a5,80005b56 <consoleintr+0x3c>
      cons.e--;
    80005c46:	37fd                	addiw	a5,a5,-1
    80005c48:	0023c717          	auipc	a4,0x23c
    80005c4c:	0cf72423          	sw	a5,200(a4) # 80241d10 <cons+0xa0>
      consputc(BACKSPACE);
    80005c50:	10000513          	li	a0,256
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	e84080e7          	jalr	-380(ra) # 80005ad8 <consputc>
    80005c5c:	bded                	j	80005b56 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c5e:	ee048ce3          	beqz	s1,80005b56 <consoleintr+0x3c>
    80005c62:	bf21                	j	80005b7a <consoleintr+0x60>
      consputc(c);
    80005c64:	4529                	li	a0,10
    80005c66:	00000097          	auipc	ra,0x0
    80005c6a:	e72080e7          	jalr	-398(ra) # 80005ad8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c6e:	0023c797          	auipc	a5,0x23c
    80005c72:	00278793          	addi	a5,a5,2 # 80241c70 <cons>
    80005c76:	0a07a703          	lw	a4,160(a5)
    80005c7a:	0017069b          	addiw	a3,a4,1
    80005c7e:	0006861b          	sext.w	a2,a3
    80005c82:	0ad7a023          	sw	a3,160(a5)
    80005c86:	07f77713          	andi	a4,a4,127
    80005c8a:	97ba                	add	a5,a5,a4
    80005c8c:	4729                	li	a4,10
    80005c8e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c92:	0023c797          	auipc	a5,0x23c
    80005c96:	06c7ad23          	sw	a2,122(a5) # 80241d0c <cons+0x9c>
        wakeup(&cons.r);
    80005c9a:	0023c517          	auipc	a0,0x23c
    80005c9e:	06e50513          	addi	a0,a0,110 # 80241d08 <cons+0x98>
    80005ca2:	ffffc097          	auipc	ra,0xffffc
    80005ca6:	a14080e7          	jalr	-1516(ra) # 800016b6 <wakeup>
    80005caa:	b575                	j	80005b56 <consoleintr+0x3c>

0000000080005cac <consoleinit>:

void
consoleinit(void)
{
    80005cac:	1141                	addi	sp,sp,-16
    80005cae:	e406                	sd	ra,8(sp)
    80005cb0:	e022                	sd	s0,0(sp)
    80005cb2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cb4:	00003597          	auipc	a1,0x3
    80005cb8:	b0c58593          	addi	a1,a1,-1268 # 800087c0 <syscalls+0x3f0>
    80005cbc:	0023c517          	auipc	a0,0x23c
    80005cc0:	fb450513          	addi	a0,a0,-76 # 80241c70 <cons>
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	580080e7          	jalr	1408(ra) # 80006244 <initlock>

  uartinit();
    80005ccc:	00000097          	auipc	ra,0x0
    80005cd0:	32c080e7          	jalr	812(ra) # 80005ff8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cd4:	00233797          	auipc	a5,0x233
    80005cd8:	cbc78793          	addi	a5,a5,-836 # 80238990 <devsw>
    80005cdc:	00000717          	auipc	a4,0x0
    80005ce0:	ce470713          	addi	a4,a4,-796 # 800059c0 <consoleread>
    80005ce4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ce6:	00000717          	auipc	a4,0x0
    80005cea:	c7670713          	addi	a4,a4,-906 # 8000595c <consolewrite>
    80005cee:	ef98                	sd	a4,24(a5)
}
    80005cf0:	60a2                	ld	ra,8(sp)
    80005cf2:	6402                	ld	s0,0(sp)
    80005cf4:	0141                	addi	sp,sp,16
    80005cf6:	8082                	ret

0000000080005cf8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cf8:	7179                	addi	sp,sp,-48
    80005cfa:	f406                	sd	ra,40(sp)
    80005cfc:	f022                	sd	s0,32(sp)
    80005cfe:	ec26                	sd	s1,24(sp)
    80005d00:	e84a                	sd	s2,16(sp)
    80005d02:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d04:	c219                	beqz	a2,80005d0a <printint+0x12>
    80005d06:	08054763          	bltz	a0,80005d94 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d0a:	2501                	sext.w	a0,a0
    80005d0c:	4881                	li	a7,0
    80005d0e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d12:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d14:	2581                	sext.w	a1,a1
    80005d16:	00003617          	auipc	a2,0x3
    80005d1a:	ada60613          	addi	a2,a2,-1318 # 800087f0 <digits>
    80005d1e:	883a                	mv	a6,a4
    80005d20:	2705                	addiw	a4,a4,1
    80005d22:	02b577bb          	remuw	a5,a0,a1
    80005d26:	1782                	slli	a5,a5,0x20
    80005d28:	9381                	srli	a5,a5,0x20
    80005d2a:	97b2                	add	a5,a5,a2
    80005d2c:	0007c783          	lbu	a5,0(a5)
    80005d30:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d34:	0005079b          	sext.w	a5,a0
    80005d38:	02b5553b          	divuw	a0,a0,a1
    80005d3c:	0685                	addi	a3,a3,1
    80005d3e:	feb7f0e3          	bgeu	a5,a1,80005d1e <printint+0x26>

  if(sign)
    80005d42:	00088c63          	beqz	a7,80005d5a <printint+0x62>
    buf[i++] = '-';
    80005d46:	fe070793          	addi	a5,a4,-32
    80005d4a:	00878733          	add	a4,a5,s0
    80005d4e:	02d00793          	li	a5,45
    80005d52:	fef70823          	sb	a5,-16(a4)
    80005d56:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d5a:	02e05763          	blez	a4,80005d88 <printint+0x90>
    80005d5e:	fd040793          	addi	a5,s0,-48
    80005d62:	00e784b3          	add	s1,a5,a4
    80005d66:	fff78913          	addi	s2,a5,-1
    80005d6a:	993a                	add	s2,s2,a4
    80005d6c:	377d                	addiw	a4,a4,-1
    80005d6e:	1702                	slli	a4,a4,0x20
    80005d70:	9301                	srli	a4,a4,0x20
    80005d72:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d76:	fff4c503          	lbu	a0,-1(s1)
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	d5e080e7          	jalr	-674(ra) # 80005ad8 <consputc>
  while(--i >= 0)
    80005d82:	14fd                	addi	s1,s1,-1
    80005d84:	ff2499e3          	bne	s1,s2,80005d76 <printint+0x7e>
}
    80005d88:	70a2                	ld	ra,40(sp)
    80005d8a:	7402                	ld	s0,32(sp)
    80005d8c:	64e2                	ld	s1,24(sp)
    80005d8e:	6942                	ld	s2,16(sp)
    80005d90:	6145                	addi	sp,sp,48
    80005d92:	8082                	ret
    x = -xx;
    80005d94:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d98:	4885                	li	a7,1
    x = -xx;
    80005d9a:	bf95                	j	80005d0e <printint+0x16>

0000000080005d9c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d9c:	1101                	addi	sp,sp,-32
    80005d9e:	ec06                	sd	ra,24(sp)
    80005da0:	e822                	sd	s0,16(sp)
    80005da2:	e426                	sd	s1,8(sp)
    80005da4:	1000                	addi	s0,sp,32
    80005da6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005da8:	0023c797          	auipc	a5,0x23c
    80005dac:	f807a423          	sw	zero,-120(a5) # 80241d30 <pr+0x18>
  printf("panic: ");
    80005db0:	00003517          	auipc	a0,0x3
    80005db4:	a1850513          	addi	a0,a0,-1512 # 800087c8 <syscalls+0x3f8>
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	02e080e7          	jalr	46(ra) # 80005de6 <printf>
  printf(s);
    80005dc0:	8526                	mv	a0,s1
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	024080e7          	jalr	36(ra) # 80005de6 <printf>
  printf("\n");
    80005dca:	00002517          	auipc	a0,0x2
    80005dce:	27e50513          	addi	a0,a0,638 # 80008048 <etext+0x48>
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	014080e7          	jalr	20(ra) # 80005de6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dda:	4785                	li	a5,1
    80005ddc:	00003717          	auipc	a4,0x3
    80005de0:	aef72823          	sw	a5,-1296(a4) # 800088cc <panicked>
  for(;;)
    80005de4:	a001                	j	80005de4 <panic+0x48>

0000000080005de6 <printf>:
{
    80005de6:	7131                	addi	sp,sp,-192
    80005de8:	fc86                	sd	ra,120(sp)
    80005dea:	f8a2                	sd	s0,112(sp)
    80005dec:	f4a6                	sd	s1,104(sp)
    80005dee:	f0ca                	sd	s2,96(sp)
    80005df0:	ecce                	sd	s3,88(sp)
    80005df2:	e8d2                	sd	s4,80(sp)
    80005df4:	e4d6                	sd	s5,72(sp)
    80005df6:	e0da                	sd	s6,64(sp)
    80005df8:	fc5e                	sd	s7,56(sp)
    80005dfa:	f862                	sd	s8,48(sp)
    80005dfc:	f466                	sd	s9,40(sp)
    80005dfe:	f06a                	sd	s10,32(sp)
    80005e00:	ec6e                	sd	s11,24(sp)
    80005e02:	0100                	addi	s0,sp,128
    80005e04:	8a2a                	mv	s4,a0
    80005e06:	e40c                	sd	a1,8(s0)
    80005e08:	e810                	sd	a2,16(s0)
    80005e0a:	ec14                	sd	a3,24(s0)
    80005e0c:	f018                	sd	a4,32(s0)
    80005e0e:	f41c                	sd	a5,40(s0)
    80005e10:	03043823          	sd	a6,48(s0)
    80005e14:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e18:	0023cd97          	auipc	s11,0x23c
    80005e1c:	f18dad83          	lw	s11,-232(s11) # 80241d30 <pr+0x18>
  if(locking)
    80005e20:	020d9b63          	bnez	s11,80005e56 <printf+0x70>
  if (fmt == 0)
    80005e24:	040a0263          	beqz	s4,80005e68 <printf+0x82>
  va_start(ap, fmt);
    80005e28:	00840793          	addi	a5,s0,8
    80005e2c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e30:	000a4503          	lbu	a0,0(s4)
    80005e34:	14050f63          	beqz	a0,80005f92 <printf+0x1ac>
    80005e38:	4981                	li	s3,0
    if(c != '%'){
    80005e3a:	02500a93          	li	s5,37
    switch(c){
    80005e3e:	07000b93          	li	s7,112
  consputc('x');
    80005e42:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e44:	00003b17          	auipc	s6,0x3
    80005e48:	9acb0b13          	addi	s6,s6,-1620 # 800087f0 <digits>
    switch(c){
    80005e4c:	07300c93          	li	s9,115
    80005e50:	06400c13          	li	s8,100
    80005e54:	a82d                	j	80005e8e <printf+0xa8>
    acquire(&pr.lock);
    80005e56:	0023c517          	auipc	a0,0x23c
    80005e5a:	ec250513          	addi	a0,a0,-318 # 80241d18 <pr>
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	476080e7          	jalr	1142(ra) # 800062d4 <acquire>
    80005e66:	bf7d                	j	80005e24 <printf+0x3e>
    panic("null fmt");
    80005e68:	00003517          	auipc	a0,0x3
    80005e6c:	97050513          	addi	a0,a0,-1680 # 800087d8 <syscalls+0x408>
    80005e70:	00000097          	auipc	ra,0x0
    80005e74:	f2c080e7          	jalr	-212(ra) # 80005d9c <panic>
      consputc(c);
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	c60080e7          	jalr	-928(ra) # 80005ad8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e80:	2985                	addiw	s3,s3,1
    80005e82:	013a07b3          	add	a5,s4,s3
    80005e86:	0007c503          	lbu	a0,0(a5)
    80005e8a:	10050463          	beqz	a0,80005f92 <printf+0x1ac>
    if(c != '%'){
    80005e8e:	ff5515e3          	bne	a0,s5,80005e78 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e92:	2985                	addiw	s3,s3,1
    80005e94:	013a07b3          	add	a5,s4,s3
    80005e98:	0007c783          	lbu	a5,0(a5)
    80005e9c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ea0:	cbed                	beqz	a5,80005f92 <printf+0x1ac>
    switch(c){
    80005ea2:	05778a63          	beq	a5,s7,80005ef6 <printf+0x110>
    80005ea6:	02fbf663          	bgeu	s7,a5,80005ed2 <printf+0xec>
    80005eaa:	09978863          	beq	a5,s9,80005f3a <printf+0x154>
    80005eae:	07800713          	li	a4,120
    80005eb2:	0ce79563          	bne	a5,a4,80005f7c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005eb6:	f8843783          	ld	a5,-120(s0)
    80005eba:	00878713          	addi	a4,a5,8
    80005ebe:	f8e43423          	sd	a4,-120(s0)
    80005ec2:	4605                	li	a2,1
    80005ec4:	85ea                	mv	a1,s10
    80005ec6:	4388                	lw	a0,0(a5)
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	e30080e7          	jalr	-464(ra) # 80005cf8 <printint>
      break;
    80005ed0:	bf45                	j	80005e80 <printf+0x9a>
    switch(c){
    80005ed2:	09578f63          	beq	a5,s5,80005f70 <printf+0x18a>
    80005ed6:	0b879363          	bne	a5,s8,80005f7c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005eda:	f8843783          	ld	a5,-120(s0)
    80005ede:	00878713          	addi	a4,a5,8
    80005ee2:	f8e43423          	sd	a4,-120(s0)
    80005ee6:	4605                	li	a2,1
    80005ee8:	45a9                	li	a1,10
    80005eea:	4388                	lw	a0,0(a5)
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	e0c080e7          	jalr	-500(ra) # 80005cf8 <printint>
      break;
    80005ef4:	b771                	j	80005e80 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ef6:	f8843783          	ld	a5,-120(s0)
    80005efa:	00878713          	addi	a4,a5,8
    80005efe:	f8e43423          	sd	a4,-120(s0)
    80005f02:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f06:	03000513          	li	a0,48
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	bce080e7          	jalr	-1074(ra) # 80005ad8 <consputc>
  consputc('x');
    80005f12:	07800513          	li	a0,120
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	bc2080e7          	jalr	-1086(ra) # 80005ad8 <consputc>
    80005f1e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f20:	03c95793          	srli	a5,s2,0x3c
    80005f24:	97da                	add	a5,a5,s6
    80005f26:	0007c503          	lbu	a0,0(a5)
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	bae080e7          	jalr	-1106(ra) # 80005ad8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f32:	0912                	slli	s2,s2,0x4
    80005f34:	34fd                	addiw	s1,s1,-1
    80005f36:	f4ed                	bnez	s1,80005f20 <printf+0x13a>
    80005f38:	b7a1                	j	80005e80 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f3a:	f8843783          	ld	a5,-120(s0)
    80005f3e:	00878713          	addi	a4,a5,8
    80005f42:	f8e43423          	sd	a4,-120(s0)
    80005f46:	6384                	ld	s1,0(a5)
    80005f48:	cc89                	beqz	s1,80005f62 <printf+0x17c>
      for(; *s; s++)
    80005f4a:	0004c503          	lbu	a0,0(s1)
    80005f4e:	d90d                	beqz	a0,80005e80 <printf+0x9a>
        consputc(*s);
    80005f50:	00000097          	auipc	ra,0x0
    80005f54:	b88080e7          	jalr	-1144(ra) # 80005ad8 <consputc>
      for(; *s; s++)
    80005f58:	0485                	addi	s1,s1,1
    80005f5a:	0004c503          	lbu	a0,0(s1)
    80005f5e:	f96d                	bnez	a0,80005f50 <printf+0x16a>
    80005f60:	b705                	j	80005e80 <printf+0x9a>
        s = "(null)";
    80005f62:	00003497          	auipc	s1,0x3
    80005f66:	86e48493          	addi	s1,s1,-1938 # 800087d0 <syscalls+0x400>
      for(; *s; s++)
    80005f6a:	02800513          	li	a0,40
    80005f6e:	b7cd                	j	80005f50 <printf+0x16a>
      consputc('%');
    80005f70:	8556                	mv	a0,s5
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	b66080e7          	jalr	-1178(ra) # 80005ad8 <consputc>
      break;
    80005f7a:	b719                	j	80005e80 <printf+0x9a>
      consputc('%');
    80005f7c:	8556                	mv	a0,s5
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	b5a080e7          	jalr	-1190(ra) # 80005ad8 <consputc>
      consputc(c);
    80005f86:	8526                	mv	a0,s1
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	b50080e7          	jalr	-1200(ra) # 80005ad8 <consputc>
      break;
    80005f90:	bdc5                	j	80005e80 <printf+0x9a>
  if(locking)
    80005f92:	020d9163          	bnez	s11,80005fb4 <printf+0x1ce>
}
    80005f96:	70e6                	ld	ra,120(sp)
    80005f98:	7446                	ld	s0,112(sp)
    80005f9a:	74a6                	ld	s1,104(sp)
    80005f9c:	7906                	ld	s2,96(sp)
    80005f9e:	69e6                	ld	s3,88(sp)
    80005fa0:	6a46                	ld	s4,80(sp)
    80005fa2:	6aa6                	ld	s5,72(sp)
    80005fa4:	6b06                	ld	s6,64(sp)
    80005fa6:	7be2                	ld	s7,56(sp)
    80005fa8:	7c42                	ld	s8,48(sp)
    80005faa:	7ca2                	ld	s9,40(sp)
    80005fac:	7d02                	ld	s10,32(sp)
    80005fae:	6de2                	ld	s11,24(sp)
    80005fb0:	6129                	addi	sp,sp,192
    80005fb2:	8082                	ret
    release(&pr.lock);
    80005fb4:	0023c517          	auipc	a0,0x23c
    80005fb8:	d6450513          	addi	a0,a0,-668 # 80241d18 <pr>
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	3cc080e7          	jalr	972(ra) # 80006388 <release>
}
    80005fc4:	bfc9                	j	80005f96 <printf+0x1b0>

0000000080005fc6 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fc6:	1101                	addi	sp,sp,-32
    80005fc8:	ec06                	sd	ra,24(sp)
    80005fca:	e822                	sd	s0,16(sp)
    80005fcc:	e426                	sd	s1,8(sp)
    80005fce:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fd0:	0023c497          	auipc	s1,0x23c
    80005fd4:	d4848493          	addi	s1,s1,-696 # 80241d18 <pr>
    80005fd8:	00003597          	auipc	a1,0x3
    80005fdc:	81058593          	addi	a1,a1,-2032 # 800087e8 <syscalls+0x418>
    80005fe0:	8526                	mv	a0,s1
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	262080e7          	jalr	610(ra) # 80006244 <initlock>
  pr.locking = 1;
    80005fea:	4785                	li	a5,1
    80005fec:	cc9c                	sw	a5,24(s1)
}
    80005fee:	60e2                	ld	ra,24(sp)
    80005ff0:	6442                	ld	s0,16(sp)
    80005ff2:	64a2                	ld	s1,8(sp)
    80005ff4:	6105                	addi	sp,sp,32
    80005ff6:	8082                	ret

0000000080005ff8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ff8:	1141                	addi	sp,sp,-16
    80005ffa:	e406                	sd	ra,8(sp)
    80005ffc:	e022                	sd	s0,0(sp)
    80005ffe:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006000:	100007b7          	lui	a5,0x10000
    80006004:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006008:	f8000713          	li	a4,-128
    8000600c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006010:	470d                	li	a4,3
    80006012:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006016:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000601a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000601e:	469d                	li	a3,7
    80006020:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006024:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006028:	00002597          	auipc	a1,0x2
    8000602c:	7e058593          	addi	a1,a1,2016 # 80008808 <digits+0x18>
    80006030:	0023c517          	auipc	a0,0x23c
    80006034:	d0850513          	addi	a0,a0,-760 # 80241d38 <uart_tx_lock>
    80006038:	00000097          	auipc	ra,0x0
    8000603c:	20c080e7          	jalr	524(ra) # 80006244 <initlock>
}
    80006040:	60a2                	ld	ra,8(sp)
    80006042:	6402                	ld	s0,0(sp)
    80006044:	0141                	addi	sp,sp,16
    80006046:	8082                	ret

0000000080006048 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006048:	1101                	addi	sp,sp,-32
    8000604a:	ec06                	sd	ra,24(sp)
    8000604c:	e822                	sd	s0,16(sp)
    8000604e:	e426                	sd	s1,8(sp)
    80006050:	1000                	addi	s0,sp,32
    80006052:	84aa                	mv	s1,a0
  push_off();
    80006054:	00000097          	auipc	ra,0x0
    80006058:	234080e7          	jalr	564(ra) # 80006288 <push_off>

  if(panicked){
    8000605c:	00003797          	auipc	a5,0x3
    80006060:	8707a783          	lw	a5,-1936(a5) # 800088cc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006064:	10000737          	lui	a4,0x10000
  if(panicked){
    80006068:	c391                	beqz	a5,8000606c <uartputc_sync+0x24>
    for(;;)
    8000606a:	a001                	j	8000606a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000606c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006070:	0207f793          	andi	a5,a5,32
    80006074:	dfe5                	beqz	a5,8000606c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006076:	0ff4f513          	zext.b	a0,s1
    8000607a:	100007b7          	lui	a5,0x10000
    8000607e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006082:	00000097          	auipc	ra,0x0
    80006086:	2a6080e7          	jalr	678(ra) # 80006328 <pop_off>
}
    8000608a:	60e2                	ld	ra,24(sp)
    8000608c:	6442                	ld	s0,16(sp)
    8000608e:	64a2                	ld	s1,8(sp)
    80006090:	6105                	addi	sp,sp,32
    80006092:	8082                	ret

0000000080006094 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006094:	00003797          	auipc	a5,0x3
    80006098:	83c7b783          	ld	a5,-1988(a5) # 800088d0 <uart_tx_r>
    8000609c:	00003717          	auipc	a4,0x3
    800060a0:	83c73703          	ld	a4,-1988(a4) # 800088d8 <uart_tx_w>
    800060a4:	06f70a63          	beq	a4,a5,80006118 <uartstart+0x84>
{
    800060a8:	7139                	addi	sp,sp,-64
    800060aa:	fc06                	sd	ra,56(sp)
    800060ac:	f822                	sd	s0,48(sp)
    800060ae:	f426                	sd	s1,40(sp)
    800060b0:	f04a                	sd	s2,32(sp)
    800060b2:	ec4e                	sd	s3,24(sp)
    800060b4:	e852                	sd	s4,16(sp)
    800060b6:	e456                	sd	s5,8(sp)
    800060b8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060ba:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060be:	0023ca17          	auipc	s4,0x23c
    800060c2:	c7aa0a13          	addi	s4,s4,-902 # 80241d38 <uart_tx_lock>
    uart_tx_r += 1;
    800060c6:	00003497          	auipc	s1,0x3
    800060ca:	80a48493          	addi	s1,s1,-2038 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060ce:	00003997          	auipc	s3,0x3
    800060d2:	80a98993          	addi	s3,s3,-2038 # 800088d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060d6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060da:	02077713          	andi	a4,a4,32
    800060de:	c705                	beqz	a4,80006106 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060e0:	01f7f713          	andi	a4,a5,31
    800060e4:	9752                	add	a4,a4,s4
    800060e6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060ea:	0785                	addi	a5,a5,1
    800060ec:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060ee:	8526                	mv	a0,s1
    800060f0:	ffffb097          	auipc	ra,0xffffb
    800060f4:	5c6080e7          	jalr	1478(ra) # 800016b6 <wakeup>
    
    WriteReg(THR, c);
    800060f8:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060fc:	609c                	ld	a5,0(s1)
    800060fe:	0009b703          	ld	a4,0(s3)
    80006102:	fcf71ae3          	bne	a4,a5,800060d6 <uartstart+0x42>
  }
}
    80006106:	70e2                	ld	ra,56(sp)
    80006108:	7442                	ld	s0,48(sp)
    8000610a:	74a2                	ld	s1,40(sp)
    8000610c:	7902                	ld	s2,32(sp)
    8000610e:	69e2                	ld	s3,24(sp)
    80006110:	6a42                	ld	s4,16(sp)
    80006112:	6aa2                	ld	s5,8(sp)
    80006114:	6121                	addi	sp,sp,64
    80006116:	8082                	ret
    80006118:	8082                	ret

000000008000611a <uartputc>:
{
    8000611a:	7179                	addi	sp,sp,-48
    8000611c:	f406                	sd	ra,40(sp)
    8000611e:	f022                	sd	s0,32(sp)
    80006120:	ec26                	sd	s1,24(sp)
    80006122:	e84a                	sd	s2,16(sp)
    80006124:	e44e                	sd	s3,8(sp)
    80006126:	e052                	sd	s4,0(sp)
    80006128:	1800                	addi	s0,sp,48
    8000612a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000612c:	0023c517          	auipc	a0,0x23c
    80006130:	c0c50513          	addi	a0,a0,-1012 # 80241d38 <uart_tx_lock>
    80006134:	00000097          	auipc	ra,0x0
    80006138:	1a0080e7          	jalr	416(ra) # 800062d4 <acquire>
  if(panicked){
    8000613c:	00002797          	auipc	a5,0x2
    80006140:	7907a783          	lw	a5,1936(a5) # 800088cc <panicked>
    80006144:	e7c9                	bnez	a5,800061ce <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006146:	00002717          	auipc	a4,0x2
    8000614a:	79273703          	ld	a4,1938(a4) # 800088d8 <uart_tx_w>
    8000614e:	00002797          	auipc	a5,0x2
    80006152:	7827b783          	ld	a5,1922(a5) # 800088d0 <uart_tx_r>
    80006156:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000615a:	0023c997          	auipc	s3,0x23c
    8000615e:	bde98993          	addi	s3,s3,-1058 # 80241d38 <uart_tx_lock>
    80006162:	00002497          	auipc	s1,0x2
    80006166:	76e48493          	addi	s1,s1,1902 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000616a:	00002917          	auipc	s2,0x2
    8000616e:	76e90913          	addi	s2,s2,1902 # 800088d8 <uart_tx_w>
    80006172:	00e79f63          	bne	a5,a4,80006190 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006176:	85ce                	mv	a1,s3
    80006178:	8526                	mv	a0,s1
    8000617a:	ffffb097          	auipc	ra,0xffffb
    8000617e:	4d8080e7          	jalr	1240(ra) # 80001652 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006182:	00093703          	ld	a4,0(s2)
    80006186:	609c                	ld	a5,0(s1)
    80006188:	02078793          	addi	a5,a5,32
    8000618c:	fee785e3          	beq	a5,a4,80006176 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006190:	0023c497          	auipc	s1,0x23c
    80006194:	ba848493          	addi	s1,s1,-1112 # 80241d38 <uart_tx_lock>
    80006198:	01f77793          	andi	a5,a4,31
    8000619c:	97a6                	add	a5,a5,s1
    8000619e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800061a2:	0705                	addi	a4,a4,1
    800061a4:	00002797          	auipc	a5,0x2
    800061a8:	72e7ba23          	sd	a4,1844(a5) # 800088d8 <uart_tx_w>
  uartstart();
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	ee8080e7          	jalr	-280(ra) # 80006094 <uartstart>
  release(&uart_tx_lock);
    800061b4:	8526                	mv	a0,s1
    800061b6:	00000097          	auipc	ra,0x0
    800061ba:	1d2080e7          	jalr	466(ra) # 80006388 <release>
}
    800061be:	70a2                	ld	ra,40(sp)
    800061c0:	7402                	ld	s0,32(sp)
    800061c2:	64e2                	ld	s1,24(sp)
    800061c4:	6942                	ld	s2,16(sp)
    800061c6:	69a2                	ld	s3,8(sp)
    800061c8:	6a02                	ld	s4,0(sp)
    800061ca:	6145                	addi	sp,sp,48
    800061cc:	8082                	ret
    for(;;)
    800061ce:	a001                	j	800061ce <uartputc+0xb4>

00000000800061d0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061d0:	1141                	addi	sp,sp,-16
    800061d2:	e422                	sd	s0,8(sp)
    800061d4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061d6:	100007b7          	lui	a5,0x10000
    800061da:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061de:	8b85                	andi	a5,a5,1
    800061e0:	cb81                	beqz	a5,800061f0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061e2:	100007b7          	lui	a5,0x10000
    800061e6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061ea:	6422                	ld	s0,8(sp)
    800061ec:	0141                	addi	sp,sp,16
    800061ee:	8082                	ret
    return -1;
    800061f0:	557d                	li	a0,-1
    800061f2:	bfe5                	j	800061ea <uartgetc+0x1a>

00000000800061f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061f4:	1101                	addi	sp,sp,-32
    800061f6:	ec06                	sd	ra,24(sp)
    800061f8:	e822                	sd	s0,16(sp)
    800061fa:	e426                	sd	s1,8(sp)
    800061fc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061fe:	54fd                	li	s1,-1
    80006200:	a029                	j	8000620a <uartintr+0x16>
      break;
    consoleintr(c);
    80006202:	00000097          	auipc	ra,0x0
    80006206:	918080e7          	jalr	-1768(ra) # 80005b1a <consoleintr>
    int c = uartgetc();
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	fc6080e7          	jalr	-58(ra) # 800061d0 <uartgetc>
    if(c == -1)
    80006212:	fe9518e3          	bne	a0,s1,80006202 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006216:	0023c497          	auipc	s1,0x23c
    8000621a:	b2248493          	addi	s1,s1,-1246 # 80241d38 <uart_tx_lock>
    8000621e:	8526                	mv	a0,s1
    80006220:	00000097          	auipc	ra,0x0
    80006224:	0b4080e7          	jalr	180(ra) # 800062d4 <acquire>
  uartstart();
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	e6c080e7          	jalr	-404(ra) # 80006094 <uartstart>
  release(&uart_tx_lock);
    80006230:	8526                	mv	a0,s1
    80006232:	00000097          	auipc	ra,0x0
    80006236:	156080e7          	jalr	342(ra) # 80006388 <release>
}
    8000623a:	60e2                	ld	ra,24(sp)
    8000623c:	6442                	ld	s0,16(sp)
    8000623e:	64a2                	ld	s1,8(sp)
    80006240:	6105                	addi	sp,sp,32
    80006242:	8082                	ret

0000000080006244 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006244:	1141                	addi	sp,sp,-16
    80006246:	e422                	sd	s0,8(sp)
    80006248:	0800                	addi	s0,sp,16
  lk->name = name;
    8000624a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000624c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006250:	00053823          	sd	zero,16(a0)
}
    80006254:	6422                	ld	s0,8(sp)
    80006256:	0141                	addi	sp,sp,16
    80006258:	8082                	ret

000000008000625a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000625a:	411c                	lw	a5,0(a0)
    8000625c:	e399                	bnez	a5,80006262 <holding+0x8>
    8000625e:	4501                	li	a0,0
  return r;
}
    80006260:	8082                	ret
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000626c:	6904                	ld	s1,16(a0)
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	d20080e7          	jalr	-736(ra) # 80000f8e <mycpu>
    80006276:	40a48533          	sub	a0,s1,a0
    8000627a:	00153513          	seqz	a0,a0
}
    8000627e:	60e2                	ld	ra,24(sp)
    80006280:	6442                	ld	s0,16(sp)
    80006282:	64a2                	ld	s1,8(sp)
    80006284:	6105                	addi	sp,sp,32
    80006286:	8082                	ret

0000000080006288 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006288:	1101                	addi	sp,sp,-32
    8000628a:	ec06                	sd	ra,24(sp)
    8000628c:	e822                	sd	s0,16(sp)
    8000628e:	e426                	sd	s1,8(sp)
    80006290:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006292:	100024f3          	csrr	s1,sstatus
    80006296:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000629a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000629c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062a0:	ffffb097          	auipc	ra,0xffffb
    800062a4:	cee080e7          	jalr	-786(ra) # 80000f8e <mycpu>
    800062a8:	5d3c                	lw	a5,120(a0)
    800062aa:	cf89                	beqz	a5,800062c4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	ce2080e7          	jalr	-798(ra) # 80000f8e <mycpu>
    800062b4:	5d3c                	lw	a5,120(a0)
    800062b6:	2785                	addiw	a5,a5,1
    800062b8:	dd3c                	sw	a5,120(a0)
}
    800062ba:	60e2                	ld	ra,24(sp)
    800062bc:	6442                	ld	s0,16(sp)
    800062be:	64a2                	ld	s1,8(sp)
    800062c0:	6105                	addi	sp,sp,32
    800062c2:	8082                	ret
    mycpu()->intena = old;
    800062c4:	ffffb097          	auipc	ra,0xffffb
    800062c8:	cca080e7          	jalr	-822(ra) # 80000f8e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062cc:	8085                	srli	s1,s1,0x1
    800062ce:	8885                	andi	s1,s1,1
    800062d0:	dd64                	sw	s1,124(a0)
    800062d2:	bfe9                	j	800062ac <push_off+0x24>

00000000800062d4 <acquire>:
{
    800062d4:	1101                	addi	sp,sp,-32
    800062d6:	ec06                	sd	ra,24(sp)
    800062d8:	e822                	sd	s0,16(sp)
    800062da:	e426                	sd	s1,8(sp)
    800062dc:	1000                	addi	s0,sp,32
    800062de:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	fa8080e7          	jalr	-88(ra) # 80006288 <push_off>
  if(holding(lk))
    800062e8:	8526                	mv	a0,s1
    800062ea:	00000097          	auipc	ra,0x0
    800062ee:	f70080e7          	jalr	-144(ra) # 8000625a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f2:	4705                	li	a4,1
  if(holding(lk))
    800062f4:	e115                	bnez	a0,80006318 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f6:	87ba                	mv	a5,a4
    800062f8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062fc:	2781                	sext.w	a5,a5
    800062fe:	ffe5                	bnez	a5,800062f6 <acquire+0x22>
  __sync_synchronize();
    80006300:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006304:	ffffb097          	auipc	ra,0xffffb
    80006308:	c8a080e7          	jalr	-886(ra) # 80000f8e <mycpu>
    8000630c:	e888                	sd	a0,16(s1)
}
    8000630e:	60e2                	ld	ra,24(sp)
    80006310:	6442                	ld	s0,16(sp)
    80006312:	64a2                	ld	s1,8(sp)
    80006314:	6105                	addi	sp,sp,32
    80006316:	8082                	ret
    panic("acquire");
    80006318:	00002517          	auipc	a0,0x2
    8000631c:	4f850513          	addi	a0,a0,1272 # 80008810 <digits+0x20>
    80006320:	00000097          	auipc	ra,0x0
    80006324:	a7c080e7          	jalr	-1412(ra) # 80005d9c <panic>

0000000080006328 <pop_off>:

void
pop_off(void)
{
    80006328:	1141                	addi	sp,sp,-16
    8000632a:	e406                	sd	ra,8(sp)
    8000632c:	e022                	sd	s0,0(sp)
    8000632e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006330:	ffffb097          	auipc	ra,0xffffb
    80006334:	c5e080e7          	jalr	-930(ra) # 80000f8e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006338:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000633c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000633e:	e78d                	bnez	a5,80006368 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006340:	5d3c                	lw	a5,120(a0)
    80006342:	02f05b63          	blez	a5,80006378 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006346:	37fd                	addiw	a5,a5,-1
    80006348:	0007871b          	sext.w	a4,a5
    8000634c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000634e:	eb09                	bnez	a4,80006360 <pop_off+0x38>
    80006350:	5d7c                	lw	a5,124(a0)
    80006352:	c799                	beqz	a5,80006360 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006354:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006358:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000635c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006360:	60a2                	ld	ra,8(sp)
    80006362:	6402                	ld	s0,0(sp)
    80006364:	0141                	addi	sp,sp,16
    80006366:	8082                	ret
    panic("pop_off - interruptible");
    80006368:	00002517          	auipc	a0,0x2
    8000636c:	4b050513          	addi	a0,a0,1200 # 80008818 <digits+0x28>
    80006370:	00000097          	auipc	ra,0x0
    80006374:	a2c080e7          	jalr	-1492(ra) # 80005d9c <panic>
    panic("pop_off");
    80006378:	00002517          	auipc	a0,0x2
    8000637c:	4b850513          	addi	a0,a0,1208 # 80008830 <digits+0x40>
    80006380:	00000097          	auipc	ra,0x0
    80006384:	a1c080e7          	jalr	-1508(ra) # 80005d9c <panic>

0000000080006388 <release>:
{
    80006388:	1101                	addi	sp,sp,-32
    8000638a:	ec06                	sd	ra,24(sp)
    8000638c:	e822                	sd	s0,16(sp)
    8000638e:	e426                	sd	s1,8(sp)
    80006390:	1000                	addi	s0,sp,32
    80006392:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006394:	00000097          	auipc	ra,0x0
    80006398:	ec6080e7          	jalr	-314(ra) # 8000625a <holding>
    8000639c:	c115                	beqz	a0,800063c0 <release+0x38>
  lk->cpu = 0;
    8000639e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063a2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063a6:	0f50000f          	fence	iorw,ow
    800063aa:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	f7a080e7          	jalr	-134(ra) # 80006328 <pop_off>
}
    800063b6:	60e2                	ld	ra,24(sp)
    800063b8:	6442                	ld	s0,16(sp)
    800063ba:	64a2                	ld	s1,8(sp)
    800063bc:	6105                	addi	sp,sp,32
    800063be:	8082                	ret
    panic("release");
    800063c0:	00002517          	auipc	a0,0x2
    800063c4:	47850513          	addi	a0,a0,1144 # 80008838 <digits+0x48>
    800063c8:	00000097          	auipc	ra,0x0
    800063cc:	9d4080e7          	jalr	-1580(ra) # 80005d9c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
