
<!-- README.md is generated from README.Rmd. Please edit that file -->

# storytelling <img src="man/figures/hex_sticker.png" width="120" align="right" />

<!-- badges: start -->

<!-- badges: end -->

{storytelling} is an R package that provides functions to use various
Web APIs to:

- Generate fictional stories (`generate_story()`)  
- Generate image prompts based on a story (`generate_image_prompts()`)  
- Generate images based on the image prompts (`generate_images()`)  
- Generate audios (speech) from story text (`generate_audio()`)  
- Combine story text, images, and audio in a nice revealjs slide deck
  using Quarto (`create_slides()`)

Under the hood, {storytime} uses {ellmer} and {httr2}.

## Installation

You can install the development version of storytelling from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("durraniu/storytelling")
```

## Getting Started

You need Cloudflare account ID and API key for generating images.[Follow
these
instructions](https://developers.cloudflare.com/workers-ai/get-started/rest-api/)
to get the account ID and API key. Moreover, you need an API key for any
provider that {ellmer} supports. Put all the keys in your `.Renviron`
file.

### Example

Following is an example workflow to create a story slide deck:

``` r
library(storytelling)
# Provide a prompt for generating a story:
user_prompt <- "Tell me a story about a dragon who turned into a human."
story <- generate_story(user_prompt)
# [1] "Ignis, a dragon of the Crimson Peaks, lived a life of roaring flames and boundless skies. He reveled in his power, the terror he inspired, the mountains of gold he hoarded. Yet, a strange restlessness stirred within him, a longing for something beyond his dragon's existence. He saw the fleeting lives of humans in the valleys below, their laughter, their loves, their fleeting moments of joy and sorrow, and a desire bloomed within him to experience that ephemeral existence. He sought ancient magic, whispering through forgotten ruins, until he discovered a ritual promising transformation, a chance to walk among mortals, even if only for a while."
# [2] "The ritual was perilous, requiring a sacrifice of his most prized scale and the binding of his dragon heart. Underneath the pale glow of a lunar eclipse, Ignis chanted the ancient words. Agony ripped through him as his massive form shrunk and shifted. Scales turned to skin, claws to hands, wings to a strong but earthbound back. When the moon hid behind the clouds, Ignis stood as a man, naked and vulnerable, but with a heart pounding with a newfound excitement. He named himself Ash, a reminder of the fire he left behind."                                                                                                                             
# [3] "Ash descended into the valley, a stranger in a strange land. He quickly learned the ways of men, the nuances of their language, the complexities of their social structures. He found work as a blacksmith, his dragon-forged strength making him a master of the forge. He made friends, shared laughter, and even felt the pangs of love for a kind woman named Elara. He helped the villagers, using his knowledge of metalworking to create stronger tools and weapons, earning their respect and gratitude. He was no longer a terror, but a protector."                                                                                                              
# [4] "But the transformation was not without its price. The magic that bound him was fading, the dragon within stirring. Brief flashes of his former self would manifest – a sudden burst of heat, an uncontrollable urge to fly, a flicker of golden scales beneath his skin. He knew his time as Ash was limited. An old hermit, recognizing the dragon-man, warned him that his true form would eventually reclaim him, and the longer he resisted, the more destructive the change would be."                                                                                                                                                                                
# [5] "With a heavy heart, Ash bid farewell to Elara and his friends. He confessed his true nature, knowing they might fear him. Some did, but Elara saw the heart beneath the scales, the kindness that had defined his time among them. He climbed back to the Crimson Peaks, where, under the next lunar eclipse, he allowed the dragon to reclaim him. Ignis soared into the sky, the human experience forever etched into his heart, a changed dragon, more understanding, more compassionate, forever bound to the memory of his time as Ash, the blacksmith." 

# Now create prompts for image description:
image_prompts <- generate_image_prompts(story)
# [1] "Ignis, a young dragon with crimson scales, sharp horns, piercing yellow eyes, and a long, powerful tail, is surrounded by a large hoard of gems and gold coins in his cave, looking wistful and yearning for adventure, with a vast, endless sky visible through the cave entrance."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
# [2] "Ignis, now in the forgotten Sunken Temple with crumbling stone walls and ancient carvings, holding a scroll with both claws. Around him are moonpetal dew in a vial, a single phoenix feather glowing with embers, and a rare crystal pulsating with geothermal energy. His scales are shimmering, with bones contorting, and fire erupting around him, transforming into a bewildered young man with fiery red hair, fair skin, and a slender build, in a dramatic, arcane setting under the crimson glow of a blood moon."                                                                                                                                                                                                                                                                                                                                                  
# [3] "Ian, a bewildered young man with fiery red hair, fair skin, and a slender build, wearing simple, ill-fitting clothes, is stumbling into a bustling village with cobblestone streets and thatched-roof houses, looking overwhelmed by the weight of the clothes, the strange taste of bread, and the cacophony of human voices. Elara, a traveling merchant with kind eyes, braided brown hair, and wearing practical leather armor, is offering him work and shelter with a warm, welcoming smile."                                                                                                                                                                                                                                                                                                                                                                           
# [4] "Ian, a young man with fiery red hair, fair skin, and a slender build, wearing simple traveling clothes, is looking conflicted and distressed in the Shadowfen, a treacherous swamp with murky water, gnarled trees, and hanging moss. Elara, a woman with braided brown hair and wearing practical leather armor, is pressing him for answers with a concerned expression, her trust unwavering. In the background, Malkor, a ruthless sorcerer with a gaunt face, dark robes, and glowing red eyes, is sensing the dark magic emanating from the Dragon's Tooth, a relic of immense power, with a sinister smile."                                                                                                                                                                                                                                                           
# [5] "Ian, with fiery red hair, fair skin, and a slender build, now partially transformed, with crimson scales appearing on his arms and face and his eyes glowing with dragon fire, wearing torn traveling clothes, is confronting Malkor, the ruthless sorcerer, in the Shadowfen. Malkor, with a gaunt face, dark robes, and glowing red eyes, is wielding dark magic, looking furious. Elara, with braided brown hair and wearing practical leather armor, is standing beside Ian, ready to fight. Ian is shattering the Dragon's Tooth with a powerful blast of fire, severing Malkor's connection to its power, and banishing the sorcerer. Afterwards, Ian, still in his human form but with a knowing look in his eyes, is continuing to travel with Elara, now with a strong bond between them, in a serene, sunlit landscape, symbolizing their journey into the unknown."



# Provide the image prompts to generate images:
all_images <- generate_images(image_prompts, style = "ethereal_fantasy")
length(all_images)
# [1] 5

# Copy a QMD template file to a desired directory:
path <- copy_template("C:\\Users\\Your\\Path")

# Combine text and images in a revealjs slide deck:
create_slides(
  input_qmd = path,
  theme = "beige",
  title = "Dragon Becomes Human",
  story = story,
  images = all_images,
  audios = FALSE
)
```

![](man/figures/demo_slides.gif)

You can also create slides with audio playback on each slide. Here, we
use a different template that can incorporate audio input:

``` r
# Generate audio from story text:
audios <- generate_audio(story)

path2 <- copy_template("C:\\Users\\Your\\Path", audio = TRUE)

create_slides(
  input_qmd = path2,
  theme = "sky",
  title = "Dragon Turns Human",
  story = story,
  images = all_images,
  audios = audios
)
```
