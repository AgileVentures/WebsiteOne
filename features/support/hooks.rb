Before('@desktop') { page.driver.resize(1228, 768) }

Before('@tablet') { page.driver.resize(768, 768) }

Before('@smartphone') { page.driver.resize(640, 640) }

After('@desktop', '@tablet', '@smartphone') { page.driver.resize(1600, 1200) }